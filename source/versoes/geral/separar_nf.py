"""
Separador e renomeador de DANFE (NF-e) escaneadas.

- Lê o código de barras (chave de acesso de 44 dígitos) de cada página.
- Página com chave válida = início de uma nova nota.
- Páginas sem chave (continuação) são anexadas à nota anterior.
- Salva cada nota como NF_<numero>.pdf em "processadas".
- O que não for lido vai para "revisar".

As pastas ficam ao lado do .exe (ou do .py):
    entrada / processadas / revisar / originais
"""
from __future__ import annotations

import re
import shutil
import sys
import time
from pathlib import Path

try:
    import pymupdf as fitz  # PyMuPDF (versões novas)
except ImportError:  # versões antigas
    import fitz
import zxingcpp
from PIL import Image

# Pasta base: ao lado do .exe (quando empacotado) ou do .py
if getattr(sys, "frozen", False):
    BASE = Path(sys.executable).parent
else:
    BASE = Path(__file__).resolve().parent

ENTRADA = BASE / "entrada"
SAIDA = BASE / "processadas"
REVISAR = BASE / "revisar"
ORIGINAIS = BASE / "originais"
for _p in (ENTRADA, SAIDA, REVISAR, ORIGINAIS):
    _p.mkdir(parents=True, exist_ok=True)

REGISTRO = BASE / "registro_notas.csv"  # chave;arquivo (evita duplicadas entre lotes)

DPI = 300
INTERVALO_SEGUNDOS = 10


def chave_valida(c: str) -> bool:
    """Valida os 44 dígitos pelo dígito verificador (módulo 11)."""
    if len(c) != 44 or not c.isdigit():
        return False
    soma = sum(int(d) * (2 + i % 8) for i, d in enumerate(reversed(c[:43])))
    resto = soma % 11
    dv = 0 if resto in (0, 1) else 11 - resto
    return dv == int(c[43])


def ler_chave(page) -> str | None:
    pix = page.get_pixmap(dpi=DPI)
    img = Image.frombytes("RGB", (pix.width, pix.height), pix.samples)

    # 1) código de barras
    for b in zxingcpp.read_barcodes(img):
        texto = re.sub(r"\D", "", b.text)
        if chave_valida(texto):
            return texto

    # 2) OCR reserva (só funciona se o Tesseract estiver instalado)
    try:
        import pytesseract

        texto = pytesseract.image_to_string(img)
        texto = re.sub(r"[\s\.\-]", "", texto)
        for c in re.findall(r"\d{44}", texto):
            if chave_valida(c):
                return c
    except Exception:
        pass
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
    if chave in registro:  # mesma nota já processada antes
        return None
    numero = str(int(chave[25:34]))  # número da NF
    cnpj = chave[6:20]               # CNPJ do emitente
    d = SAIDA / f"NF_{numero}.pdf"
    if not d.exists():
        return d
    d = SAIDA / f"NF_{numero}_{cnpj}.pdf"  # mesmo número, emitente diferente
    return None if d.exists() else d


def nome_livre(pasta: Path, nome: str) -> Path:
    d = pasta / nome
    i = 2
    while d.exists():
        d = pasta / f"{Path(nome).stem}_{i}{Path(nome).suffix}"
        i += 1
    return d


def processar(pdf: Path) -> None:
    registro = carregar_registro()
    doc = fitz.open(pdf)
    grupos: list[list] = []  # [chave, [páginas]]
    for i, page in enumerate(doc):
        chave = ler_chave(page)
        if chave:
            grupos.append([chave, [i]])
        elif grupos:
            grupos[-1][1].append(i)
        else:
            grupos.append([None, [i]])

    for chave, paginas in grupos:
        novo = fitz.open()
        for p in paginas:
            novo.insert_pdf(doc, from_page=p, to_page=p)
        destino = destino_da_nota(chave, registro) if chave else None
        if destino is None:
            sufixo = f"_DUP_{chave}" if chave else ""
            destino = nome_livre(
                REVISAR, f"{pdf.stem}_pag{paginas[0] + 1}{sufixo}.pdf"
            )
        novo.save(destino)
        novo.close()
        if chave and destino.parent == SAIDA:
            registro[chave] = destino.name
            registrar(chave, destino.name)
        print(f"   -> {destino.parent.name}\\{destino.name}")

    doc.close()
    shutil.move(str(pdf), str(nome_livre(ORIGINAIS, pdf.name)))


def arquivo_pronto(pdf: Path) -> bool:
    """Evita pegar o arquivo enquanto o scanner ainda está gravando."""
    try:
        t1 = pdf.stat().st_size
        time.sleep(2)
        return t1 == pdf.stat().st_size and t1 > 0
    except OSError:
        return False


def main() -> None:
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
                except Exception as e:  # noqa: BLE001
                    print(f"   ERRO em {pdf.name}: {e}")
                    try:
                        shutil.move(str(pdf), str(nome_livre(REVISAR, pdf.name)))
                    except Exception:
                        pass
        time.sleep(INTERVALO_SEGUNDOS)


if __name__ == "__main__":
    main()
