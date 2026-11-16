"""
Separador e renomeador de DANFE (NF-e) escaneadas.

- LÃª o cÃ³digo de barras (chave de acesso de 44 dÃ­gitos) de cada pÃ¡gina.
- PÃ¡gina com chave vÃ¡lida = inÃ­cio de uma nova nota.
- PÃ¡ginas sem chave (continuaÃ§Ã£o) sÃ£o anexadas Ã  nota anterior.
- Salva cada nota como NF_<numero>.pdf em "processadas".
- O que nÃ£o for lido vai para "revisar".

As pastas ficam ao lado do .exe (ou do .py):
    entrada / processadas / revisar / originais
"""
from __future__ import annotations

import re
import argparse
import logging
import os
import shutil
import sys
import time
from pathlib import Path

try:
    import pymupdf as fitz  # PyMuPDF (versÃµes novas)
except ImportError:  # versÃµes antigas
    import fitz
import zxingcpp
import pytesseract
from PIL import Image, ImageEnhance, ImageFilter, ImageOps

# Os recursos imutÃ¡veis do one-file vÃªm de _MEIPASS. Dados de trabalho ficam
# em LocalAppData no executÃ¡vel instalado, nunca ao lado de Program Files.
if getattr(sys, "frozen", False):
    _local = os.environ.get("LOCALAPPDATA")
    if not _local:
        _local = str(Path.home() / "AppData" / "Local")
    BASE = Path(_local) / "Separador de Notas"
    RESOURCE_BASE = Path(getattr(sys, "_MEIPASS", BASE))
else:
    BASE = Path(__file__).resolve().parent
    RESOURCE_BASE = BASE
BASE.mkdir(parents=True, exist_ok=True)

TESSERACT_DIR = RESOURCE_BASE / "runtime" / "tesseract"
TESSERACT_EXE = TESSERACT_DIR / "tesseract.exe"
TESSDATA_DIR = TESSERACT_DIR / "tessdata"
pytesseract.pytesseract.tesseract_cmd = str(TESSERACT_EXE)
os.environ["TESSDATA_PREFIX"] = str(TESSDATA_DIR)

ENTRADA = BASE / "entrada"
SAIDA = BASE / "processadas"
REVISAR = BASE / "revisar"
ORIGINAIS = BASE / "originais"
for _p in (ENTRADA, SAIDA, REVISAR, ORIGINAIS):
    _p.mkdir(parents=True, exist_ok=True)

REGISTRO = BASE / "registro_notas.csv"  # chave;arquivo (evita duplicadas entre lotes)
LOG_PATH = BASE / "separador.log"
logging.basicConfig(
    filename=str(LOG_PATH),
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
LOGGER = logging.getLogger("separador_nf")

DPI = 300
INTERVALO_SEGUNDOS = 10


def chave_valida(c: str) -> bool:
    """Valida os 44 dÃ­gitos pelo dÃ­gito verificador (mÃ³dulo 11)."""
    if len(c) != 44 or not c.isdigit():
        return False
    soma = sum(int(d) * (2 + i % 8) for i, d in enumerate(reversed(c[:43])))
    resto = soma % 11
    dv = 0 if resto in (0, 1) else 11 - resto
    return dv == int(c[43])


def ler_chave(page) -> str | None:
    pix = page.get_pixmap(dpi=DPI)
    img = Image.frombytes("RGB", (pix.width, pix.height), pix.samples)

    # 1) cÃ³digo de barras
    for b in zxingcpp.read_barcodes(img):
        texto = re.sub(r"\D", "", b.text)
        if chave_valida(texto):
            return texto

    # 2) OCR: usa somente o Tesseract e os modelos empacotados com o aplicativo.
    try:
        if not TESSERACT_EXE.is_file():
            raise FileNotFoundError(f"Tesseract nÃ£o encontrado: {TESSERACT_EXE}")
        modelos_ausentes = [
            nome for nome in ("por.traineddata", "eng.traineddata")
            if not (TESSDATA_DIR / nome).is_file()
        ]
        if modelos_ausentes:
            raise FileNotFoundError(
                "Modelos Tesseract ausentes: " + ", ".join(modelos_ausentes)
            )

        # Escala de cinza, autocontraste e limiarizaÃ§Ã£o com Pillow.
        cinza = ImageOps.grayscale(img)
        contraste = ImageOps.autocontrast(cinza, cutoff=1)
        contraste = ImageEnhance.Contrast(contraste).enhance(1.35)
        contraste = contraste.filter(ImageFilter.MedianFilter(size=3))
        limiar = contraste.point(lambda px: 0 if px < 160 else 255, mode="1")

        # Os DANFEs podem ter a chave inclinada; tentamos pequenas rotaÃ§Ãµes
        # somente apÃ³s as passagens sem rotaÃ§Ã£o para limitar o tempo de OCR.
        variantes = [contraste, limiar]
        configs = (6, 11)
        for imagem in variantes:
            for psm in configs:
                config = (
                    f"--oem 1 --psm {psm} "
                    "-c tessedit_char_whitelist=0123456789"
                )
                dados = pytesseract.image_to_data(
                    imagem,
                    lang="por+eng",
                    config=config,
                    output_type=pytesseract.Output.DICT,
                )
                texto = " ".join(t for t in dados.get("text", []) if t)
                chave = _chave_em_texto(texto)
                if chave:
                    return chave

        for angulo in (-3, 3):
            inclinada = contraste.rotate(
                angulo, resample=Image.Resampling.BICUBIC,
                expand=False, fillcolor=255,
            )
            config = (
                "--oem 1 --psm 6 "
                "-c tessedit_char_whitelist=0123456789"
            )
            texto = pytesseract.image_to_string(
                inclinada, lang="por+eng", config=config
            )
            chave = _chave_em_texto(texto)
            if chave:
                return chave
    except Exception:
        LOGGER.exception("Falha de OCR na pÃ¡gina %s", getattr(page, "number", "?"))
    return None


def _chave_em_texto(texto: str) -> str | None:
    """Localiza janelas de 44 dÃ­gitos no OCR e valida o dÃ­gito verificador."""
    digitos = re.sub(r"\D", "", texto)
    for inicio in range(max(0, len(digitos) - 43)):
        candidata = digitos[inicio:inicio + 44]
        if len(candidata) == 44 and chave_valida(candidata):
            return candidata
    return None


def carregar_registro() -> dict[str, str]:
    if not REGISTRO.exists():
        return {}
    dados = {}
    for linha in REGISTRO.read_text(encoding="utf-8").splitlines():
        if ";" in linha:
            c, a = linha.split(";", 1)
            dados[c] = a
    return dados


def registrar(chave: str, arquivo: str) -> None:
    with REGISTRO.open("a", encoding="utf-8") as f:
        f.write(f"{chave};{arquivo}\n")


def destino_da_nota(chave: str, registro: dict[str, str]) -> Path | None:
    if chave in registro:  # mesma nota jÃ¡ processada antes
        return None
    numero = str(int(chave[25:34]))  # nÃºmero da NF
    cnpj = chave[6:20]               # CNPJ do emitente
    d = SAIDA / f"NF_{numero}.pdf"
    if not d.exists():
        return d
    d = SAIDA / f"NF_{numero}_{cnpj}.pdf"  # mesmo nÃºmero, emitente diferente
    return None if d.exists() else d


def nome_livre(pasta: Path, nome: str) -> Path:
    d = pasta / nome
    i = 2
    while d.exists():
        d = pasta / f"{Path(nome).stem}_{i}{Path(nome).suffix}"
        i += 1
    return d


def processar(pdf: Path) -> None:
    """Processa de modo transacional: sÃ³ publica resultados completos.

    Em qualquer falha antes da confirmaÃ§Ã£o, o original permanece disponÃ­vel
    para a rotina de recuperaÃ§Ã£o encaminhÃ¡-lo para revisar.
    """
    registro = carregar_registro()
    doc = fitz.open(pdf)
    staging = BASE / ".staging"
    staging.mkdir(parents=True, exist_ok=True)
    staged: list[tuple[Path, Path, str | None]] = []
    committed: list[Path] = []
    registry_original = REGISTRO.read_bytes() if REGISTRO.exists() else None
    registry_committed = False
    try:
        grupos: list[list] = []  # [chave, [pÃ¡ginas]]
        for i, page in enumerate(doc):
            chave = ler_chave(page)
            if chave:
                grupos.append([chave, [i]])
            else:
                LOGGER.warning(
                    "Nenhuma chave vÃ¡lida na pÃ¡gina %s do arquivo %s; encaminhando para revisar",
                    i + 1, pdf.name,
                )
                if grupos:
                    grupos[-1][1].append(i)
                else:
                    grupos.append([None, [i]])

        reserved: set[Path] = set()
        registry_new = dict(registro)
        for group_index, (chave, paginas) in enumerate(grupos, start=1):
            novo = fitz.open()
            try:
                for page_index in paginas:
                    novo.insert_pdf(doc, from_page=page_index, to_page=page_index)
                destino = destino_da_nota(chave, registry_new) if chave else None
                if destino is None:
                    sufixo = f"_DUP_{chave}" if chave else ""
                    destino = nome_livre(
                        REVISAR, f"{pdf.stem}_pag{paginas[0] + 1}{sufixo}.pdf"
                    )
                while destino in reserved or destino.exists():
                    destino = nome_livre(destino.parent, destino.name)
                reserved.add(destino)
                tmp = staging / f"{pdf.stem}.{os.getpid()}.{group_index}.tmp.pdf"
                novo.save(tmp)
                staged.append((tmp, destino, chave if destino.parent == SAIDA else None))
                if chave and destino.parent == SAIDA:
                    registry_new[chave] = destino.name
            finally:
                novo.close()

        doc.close()
        doc = None

        # Prepare registry atomically before publishing any output.
        registry_tmp = staging / f"registro.{os.getpid()}.tmp"
        registry_lines = [f"{key};{name}" for key, name in registry_new.items()]
        registry_tmp.write_text("\n".join(registry_lines) + ("\n" if registry_lines else ""), encoding="utf-8")

        for tmp, destino, _chave in staged:
            destino.parent.mkdir(parents=True, exist_ok=True)
            if destino.exists():
                raise FileExistsError(f"Destino apareceu durante o processamento: {destino}")
            os.rename(str(tmp), str(destino))
            committed.append(destino)

        if registry_new != registro:
            os.replace(str(registry_tmp), str(REGISTRO))
            registry_committed = True
        else:
            registry_tmp.unlink()

        original_dest = nome_livre(ORIGINAIS, pdf.name)
        shutil.move(str(pdf), str(original_dest))
        for _tmp, destino, _chave in staged:
            print(f"   -> {destino.parent.name}\\{destino.name}")
        LOGGER.info("Processamento concluÃ­do: %s -> %s", pdf.name, original_dest)
    except Exception:
        LOGGER.exception("Falha no processamento transacional de %s", pdf)
        # Reverte os resultados deste lote; o PDF de entrada permanece para
        # que main() o mova integralmente para revisar.
        for path in reversed(committed):
            try:
                path.unlink()
            except OSError:
                LOGGER.exception("NÃ£o foi possÃ­vel reverter arquivo publicado: %s", path)
        if registry_committed:
            try:
                restore_tmp = staging / f"registro.restore.{os.getpid()}.tmp"
                if registry_original is None:
                    if REGISTRO.exists():
                        REGISTRO.unlink()
                else:
                    restore_tmp.write_bytes(registry_original)
                    os.replace(str(restore_tmp), str(REGISTRO))
            except OSError:
                LOGGER.exception("NÃ£o foi possÃ­vel restaurar registro apÃ³s falha de lote")
        raise
    finally:
        if doc is not None:
            doc.close()
        for tmp, _destino, _chave in staged:
            try:
                tmp.unlink()
            except OSError:
                pass
        try:
            for leftover in staging.glob(f"*{os.getpid()}*.tmp*"):
                leftover.unlink()
        except OSError:
            LOGGER.exception("NÃ£o foi possÃ­vel limpar temporÃ¡rios em %s", staging)


def arquivo_pronto(pdf: Path) -> bool:
    """Evita pegar o arquivo enquanto o scanner ainda estÃ¡ gravando."""
    try:
        t1 = pdf.stat().st_size
        time.sleep(2)
        return t1 == pdf.stat().st_size and t1 > 0
    except OSError:
        return False


def self_check() -> int:
    """ValidaÃ§Ã£o local das extensÃµes e recursos empacotados; nÃ£o processa PDFs."""
    failures = []
    try:
        if not TESSERACT_EXE.is_file():
            raise FileNotFoundError(TESSERACT_EXE)
        languages = pytesseract.get_languages(config="")
        for language in ("por", "eng"):
            if language not in languages:
                raise RuntimeError(f"Modelo de idioma ausente: {language}")
        LOGGER.info("Self-check Tesseract %s idiomas=%s", pytesseract.get_tesseract_version(), languages)
    except Exception as exc:
        failures.append(f"Tesseract/OCR: {exc}")
        LOGGER.exception("Self-check Tesseract falhou")
    try:
        doc = fitz.open()
        page = doc.new_page(width=40, height=40)
        pix = page.get_pixmap(dpi=72)
        image = Image.frombytes("RGB", (pix.width, pix.height), pix.samples)
        image = ImageOps.autocontrast(ImageOps.grayscale(image))
        image.close()
        doc.close()
    except Exception as exc:
        failures.append(f"PyMuPDF/Pillow: {exc}")
        LOGGER.exception("Self-check PyMuPDF/Pillow falhou")
    try:
        pattern = zxingcpp.write_barcode(zxingcpp.BarcodeFormat.Code128, "SELFTEST123", width=360, height=100)
        barcode_image = Image.frombytes(
            "L", (pattern.shape[1], pattern.shape[0]), memoryview(pattern).tobytes()
        )
        decoded = zxingcpp.read_barcodes(barcode_image)
        if not decoded or decoded[0].text != "SELFTEST123":
            raise RuntimeError("ciclo sintÃ©tico de escrita/leitura do barcode falhou")
        barcode_image.close()
    except Exception as exc:
        failures.append(f"zxing-cpp: {exc}")
        LOGGER.exception("Self-check zxing-cpp falhou")
    try:
        probe = BASE / ".self-check.tmp"
        probe.write_text("ok", encoding="ascii")
        probe.unlink()
    except Exception as exc:
        failures.append(f"DiretÃ³rio de dados sem escrita: {BASE}: {exc}")
        LOGGER.exception("Self-check de gravaÃ§Ã£o falhou")

    if failures:
        print("SELF-CHECK FALHOU")
        for failure in failures:
            print(" - " + failure)
        return 1
    print("SELF-CHECK OK: PyMuPDF, Pillow, zxing-cpp, Tesseract por/eng e pasta gravÃ¡vel.")
    print(f"Dados de trabalho: {BASE}")
    return 0


def main() -> None:
    parser = argparse.ArgumentParser(description="Separador de notas fiscais PDF")
    parser.add_argument("--self-check", action="store_true", help="valida dependÃªncias sem processar documentos")
    args = parser.parse_args()
    if args.self_check:
        raise SystemExit(self_check())
    print("=" * 60)
    print(" Separador de NF-e (DANFE)")
    print(f" Pasta de trabalho: {BASE}")
    print(f" Coloque os PDFs escaneados em: {ENTRADA}")
    print(" Feche esta janela para parar.")
    print("=" * 60)
    while True:
        for pdf in sorted(ENTRADA.glob("*.pdf")):
            if arquivo_pronto(pdf):
                print(f"Processando: {pdf.name}")
                try:
                    processar(pdf)
                except Exception as e:  # o½;¶‰Ëkºwµç\€¼Ñ•Éµ½Ì‘½Ì½µÁ½¹•¹Ñ•ÌğM•ÑÕÀ”i%@½™¥¥…¥Ì½‰Ñ¥‘½Ì”¡…Í ½¹™•É¥‘¼ìi%@•áÑÉ‡µ‘¼•´Ñ½½±¡…¥¹€¸9M%L€Ì¸ÄÄ¼Ì¸ÄÈ¼Ì¸ÄÌèÉ•ÍÁ½ÍÑ…Ì‘”‘½İ¹±½…!Q50‘¥Ù•É¥É…´‘½Ì¡…Í¡•Ì½™¥¥…¥Ì”»¼™½É…´•á•ÕÑ…‘…Ì¸½µÁ¥±•È¥¹‘¥ÍÁ½»µÙ•°Á½È•ÉÉ¼‘¼±½…‘•È¹•ÍÑ”¡½ÍĞ¸Q•áÑ¼•´±¥•¹Í•Ì½9M%Lµ=Ae%9¹ÑáÑ€¸ğ((ŒŒA•¹“©¹¥…ÌÅÕ”‰±½ÅÕ•¥…´„‘¥ÍÑÉ¥‰Õ§Ÿ¼½µ•É¥…°((Ä¸<Aå5ÕA‘•±…É„‘Õ…°±¥•¹Í¥¹œA0½½µ•É¥…°¸ÍÑ”ÁÉ½©•Ñ¼»¼Ñ•´½µÁÉ½Ù…¹Ñ”‘”±¥•»„½µ•É¥…°ÉÑ¥™•à¹•´‘•¥Ï¼‘”‘¥ÍÑÉ¥‰Õ¥ÈÍ•ÔÍ‘¥¼Í½ˆA0½´…Ì½‰É¥‡ŸÕ•Ì½ÉÉ•ÍÁ½¹‘•¹Ñ•Ì¸ÍÁ¥„‘”=Ae%9€¹¼İ¡••°ƒ¤…Á•¹…ÌÕ´¥‘•¹Ñ¥™¥…‘½È‘”€Äà‰åÑ•Ì°Á½È¥ÍÍ¼¼Ñ•áÑ¼A0½™¥¥…°•ÍÓ„•´±¥•¹Í•Ì½9TµA0´Ì¸À¹ÑáÑ€ìÍÕ„¥¹±ÕÏ¼»¼ÍÕ‰ÍÑ¥ÑÕ¤ÕµÁÉ¥È…Ì½‰É¥‡ŸÕ•Ì‘„±¥•»„¸(È¸<¥¹ÍÑ…±…‘½ÈU5…¹¹¡•¥´ÑÉ…è11Ì‘”·é±Ñ¥Á±½ÌÁÉ½©•Ñ½Ì”»¼™½¤…½µÁ…¹¡…‘¼Á½È¹½Ñ¥”½µÁ±•Ñ¼‘”…‘„‰¥‰±¥½Ñ•„¸<¥¹Ù•¹Ó…É¥¼‘…Ì11Ì•ÍÓ„•´ÉÕ¹Ñ¥µ”½Ñ•ÍÍ•É…Ğ½AI=Y99¹µ‘€ì…¥¹‘„ƒ¤ÁÉ•¥Í¼½‰Ñ•È½Ù…±¥‘…È„±¥•»„‘”…‘„½É¥•´°¥¹±Õ¥¹‘¼•Ù•¹ÑÕ…¥Ì½‰É¥‡ŸÕ•Ì‘”…ÑÉ¥‰Õ§Ÿ¼°‘¥ÍÁ½¹¥‰¥±¥é‡Ÿ¼‘”™½¹Ñ•Ì”•á—ŸÕ•Ì½µ•É¥…¥Ì¸(Ì¸=ÌÑ•Éµ½Ì5¥É½Í½™Ğ±¥µ¥Ñ…´„É•‘¥ÍÑÉ¥‰Õ§Ÿ¼‘¼Y¬¬IÕ¹Ñ¥µ”„ÕÍ×…É¥½Ì±¥•¹¥…‘½Ì‘¼Y¥ÍÕ…°MÑÕ‘¥¼°Í•Õ¹‘¼½ÌÑ•Éµ½Ì…Á±¥…Ù•¥Ì¸;¼™½¤Á½ÍÏµÙ•°½µÁÉ½Ù…ÈÅÕ”¼‘¥ÍÑÉ¥‰Õ¥‘½ÈÑ•´•ÍÍ„±¥•»„¸;¼‘¥ÍÑÉ¥‰Õ¥È¼ÉÕ¹Ñ¥µ”Í•´•ÍÍ„½¹™¥Éµ‡Ÿ¼¸(Ğ¸<éá¥¹œµÁÀÑ•´±¥•»„Á…¡”´È¸À¹¼Á…½Ñ”°Á½Ë¥´Í•Ô…Ù¥Í¼½½ÁåÉ¥¡ĞÕÁÍÑÉ•…´…¥¹‘„‘•Ù”Í•È½±•Ñ…‘¼Á…É„¼Á…½Ñ”™¥¹…°¸(Ô¸9M%L»¼™½¤½µÁ¥±…‘¼¹•´¥¹½ÉÁ½É…‘¼…¼Á…½Ñ”¸<™½¹Ñ”€¹¹Í¥€ƒ¤…¹‘¥‘…Ñ¼Ó¥¹¥¼”…¥¹‘„»¼™½¤Ù…±¥‘…‘¼Á½È½µÁ¥±…‘½È¸U´ÁÉ½•ÍÍ¼ÁÉ¥Ù…‘¼‘”‰Õ¥±•ÍÓ„‘½Õµ•¹Ñ…‘¼•´	U%1}9M%M}AI%Y<¹µ‘€ìÁ•¹“©¹¥…Ì…¹Ñ•É¥½É•Ì‘”±¥•»„Í•Õ•´¥¹…±Ñ•É…‘…Ì¸((ŒŒQ•áÑ½Ì½Á¥…‘½ÌÁ…É„…½µÁ…¹¡…µ•¹Ñ¼()=ÌÑ•áÑ½Ì½±•Ñ…‘½Ì•ÍÓ¼•´±¥•¹Í•Ì½€¸<…ÉÅÕ¥Ù¼9TµA0´Ì¸À¹ÑáÑ€Ù•¥¼‘¼Í¥Ñ”½™¥¥…°9TìQ•ÍÍ•É…Ğ½µ½‘•±½Ì”éá¥¹œµÁÀÕÍ…´Á…¡”´È¸ÀìA¥±±½ÜÕÍ„Í•Ô…ÉÅÕ¥Ù¼‘”±¥•»„!A9ì½ÌÑ•Éµ½Ì‘”AåÑ¡½¸”Aå%¹ÍÑ…±±•ÈÛ©´‘…Ì‘¥ÍÑÉ¥‰Õ§ŸÕ•Ì±½…¥Ìì¼=Ae%9‘¼9M%LÙ•¥¼‘¼i%@½™¥¥…°¸<¥¹Ù•¹Ó…É¥¼‘…Ì€ÈÜ11ÌQ•ÍÍ•É…Ğ½¹Ñ¥¹Õ„•áÁ±¥¥Ñ…µ•¹Ñ”¥¹½µÁ±•Ñ¼”»¼‘•Ù”Í•ÈÑÉ…Ñ…‘¼½µ¼±¥‰•É‡Ÿ¼½µ•É¥…°¸((ŒŒI•™•Ë©¹¥…Ì½™¥¥…¥Ì((´Aå5ÕA±¥•¹Í¥¹œè¡ÑÑÁÌè¼½ÁåµÕÁ‘˜¹¥¼½±¥•¹Í¥¹œ”¡ÑÑÁÌè¼½ÁåµÕÁ‘˜¹É•…‘Ñ¡•‘½Ì¹¥¼½•¸½±…Ñ•ÍĞ½…‰½ÕĞ¹¡Ñµ°(´5¥É½Í½™ĞY¬¬É•‘¥ÍÑÉ¥‰ÕÑ¥½¸è¡ÑÑÁÌè¼½±•…É¸¹µ¥É½Í½™Ğ¹½´½•¸µÕÌ½ÁÀ½İ¥¹‘½İÌ½É•‘¥ÍÑÉ¥‰ÕÑ¥¹œµÙ¥ÍÕ…°µÁÀµ™¥±•Ì(´5¥É½Í½™ĞUIPè¡ÑÑÁÌè¼½±•…É¸¹µ¥É½Í½™Ğ¹½´½•¸µÕÌ½ÁÀ½İ¥¹‘½İÌ½Õ¹¥Ù•ÉÍ…°µÉĞµ‘•Á±½åµ•¹Ğ(´Q•ÍÍ•É…Ğ¥¹ÍÑ…±±…Ñ¥½¸½±¥•¹Í¥¹œè¡ÑÑÁÌè¼½Ñ•ÍÍ•É…Ğµ½È¹¥Ñ¡Õˆ¹¥¼½Ñ•ÍÍ‘½Œ½%¹ÍÑ…±±…Ñ¥½¸¹¡Ñµ°(´9M%L±¥•¹Í”è¡ÑÑÁÌè¼½¹Í¥Ì¹Í½ÕÉ•™½É”¹¥¼½½Ì½ÁÁ•¹‘¥á$¹¡Ñµ°(