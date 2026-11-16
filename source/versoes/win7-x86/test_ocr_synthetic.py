"""Integração OCR com PDFs sintéticos; não usa documentos de produção."""
from __future__ import annotations

import io
import tempfile
import unittest
from pathlib import Path

import fitz
import zxingcpp
from PIL import Image, ImageDraw, ImageFont
from unittest.mock import patch
import shutil

import separar_nf as app


KEY_PREFIX = "3526011234567800019555001"
FONT_PATH = Path("C:/Windows/Fonts/arial.ttf")


def make_key(invoice_number: int, valid: bool = True) -> str:
    payload = KEY_PREFIX + f"{invoice_number:09d}" + "1" + "12345678"
    checksum = sum(
        int(digit) * (2 + index % 8)
        for index, digit in enumerate(reversed(payload))
    )
    remainder = checksum % 11
    verifier = 0 if remainder in (0, 1) else 11 - remainder
    if not valid:
        verifier = (verifier + 1) % 10
    return payload + str(verifier)


def make_pdf(path: Path, key: str, case: str) -> None:
    document = fitz.open()
    page = document.new_page(width=595, height=842)

    if case == "text":
        page.insert_text((42, 105), "CHAVE DE ACESSO", fontsize=18)
        page.insert_text((42, 140), key, fontsize=17)
    else:
        if case == "barcode":
            size = (2480, 3508)
            background = 255
        elif case == "low_resolution":
            size = (800, 1131)
            font_size, position = 17, (25, 930)
            foreground, background, angle = 10, 255, 0
        else:
            size = (2480, 3508)
            font_size, position = 64, (115, 2500)
            if case == "skew_low_contrast":
                foreground, background, angle = 110, 225, 3
            else:
                foreground, background, angle = 0, 255, 0

        image = Image.new("L", size, color=background)
        if case == "barcode":
            code = zxingcpp.write_barcode(
                zxingcpp.BarcodeFormat.Code128, key, width=2100, height=320
            )
            barcode = Image.frombytes(
                "L", (code.shape[1], code.shape[0]), memoryview(code).tobytes()
            )
            image.paste(barcode, (190, 2000))
        else:
            draw = ImageDraw.Draw(image)
            font = ImageFont.truetype(str(FONT_PATH), font_size)
            draw.text(position, "CHAVE DE ACESSO", fill=foreground, font=font)
            draw.text((position[0], position[1] + font_size + 12), key,
                      fill=foreground, font=font)
            if angle:
                image = image.rotate(
                    angle, resample=Image.Resampling.BICUBIC,
                    expand=False, fillcolor=background,
                )
        buffer = io.BytesIO()
        image.save(buffer, format="PNG")
        page.insert_image(page.rect, stream=buffer.getvalue())

    document.save(path)
    document.close()


class SyntheticOcrTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory(prefix="nf-ocr-test-")
        self.root = Path(self.temp.name)
        self.input = self.root / "entrada"
        self.input.mkdir()
        app.BASE = self.root
        app.ENTRADA = self.input
        app.SAIDA = self.root / "processadas"
        app.REVISAR = self.root / "revisar"
        app.ORIGINAIS = self.root / "originais"
        app.REGISTRO = self.root / "registro_notas.csv"
        for folder in (app.SAIDA, app.REVISAR, app.ORIGINAIS):
            folder.mkdir()

    def tearDown(self) -> None:
        self.temp.cleanup()

    def check_pdf(self, case: str, number: int, valid: bool = True) -> None:
        expected = make_key(number, valid=valid)
        source = self.input / (case + ".pdf")
        make_pdf(source, expected, case)

        document = fitz.open(source)
        try:
            found = app.ler_chave(document[0])
        finally:
            document.close()
        self.assertEqual(found, expected if valid else None, case)

        app.processar(source)
        self.assertFalse(source.exists(), "PDF de teste deve ser movido para originais")
        self.assertTrue((app.ORIGINAIS / source.name).exists())
        if valid:
            self.assertTrue((app.SAIDA / f"NF_{number}.pdf").exists(), case)
        else:
            self.assertTrue(any(app.REVISAR.glob("*.pdf")), case)

    def test_selectable_text_pdf(self) -> None:
        self.check_pdf("text", 101)

    def test_scanned_legible_pdf(self) -> None:
        self.check_pdf("scanned", 102)

    def test_scanned_low_resolution_pdf(self) -> None:
        self.check_pdf("low_resolution", 103)

    def test_scanned_skewed_low_contrast_pdf(self) -> None:
        self.check_pdf("skew_low_contrast", 104)

    def test_invalid_key_goes_to_review(self) -> None:
        self.check_pdf("invalid", 105, valid=False)

    def test_barcode_is_tried_before_ocr(self) -> None:
        expected = make_key(107)
        source = self.input / "barcode.pdf"
        make_pdf(source, expected, "barcode")
        document = fitz.open(source)
        try:
            with patch.object(
                app.pytesseract, "image_to_data",
                side_effect=AssertionError("OCR foi chamado antes do barcode"),
            ):
                self.assertEqual(app.ler_chave(document[0]), expected)
        finally:
            document.close()

    def test_missing_tesseract_is_logged_and_reviewed(self) -> None:
        source = self.input / "missing_tesseract.pdf"
        make_pdf(source, make_key(106), "scanned")
        original_exe = app.TESSERACT_EXE
        app.TESSERACT_EXE = self.root / "missing" / "tesseract.exe"
        try:
            app.processar(source)
        finally:
            app.TESSERACT_EXE = original_exe
        self.assertTrue(any(app.REVISAR.glob("*.pdf")))
        self.assertTrue((app.ORIGINAIS / source.name).exists())
        self.assertTrue(app.LOG_PATH.is_file())
        self.assertIn("Tesseract não encontrado", app.LOG_PATH.read_text(errors="replace"))

    def test_access_key_checksum(self) -> None:
        valid = make_key(108)
        invalid = make_key(108, valid=False)
        self.assertEqual(len(valid), 44)
        self.assertTrue(app.chave_valida(valid))
        self.assertFalse(app.chave_valida(invalid))
        self.assertFalse(app.chave_valida(valid[:-1]))
        self.assertFalse(app.chave_valida("x" + valid[1:]))

    def test_runtime_self_check(self) -> None:
        self.assertEqual(app.self_check(), 0)

    def test_pages_without_key_are_attached_to_previous_invoice(self) -> None:
        first, second = make_key(109), make_key(110)
        document = fitz.open()
        page = document.new_page(width=595, height=842)
        page.insert_text((40, 100), first, fontsize=18)
        document.new_page(width=595, height=842)  # continuation page
        page = document.new_page(width=595, height=842)
        page.insert_text((40, 100), second, fontsize=18)
        source = self.input / "duas_notas.pdf"
        document.save(source)
        document.close()

        app.processar(source)
        with fitz.open(app.SAIDA / "NF_109.pdf") as result:
            self.assertEqual(result.page_count, 2)
        with fitz.open(app.SAIDA / "NF_110.pdf") as result:
            self.assertEqual(result.page_count, 1)
        self.assertTrue((app.ORIGINAIS / source.name).exists())

    def test_duplicate_key_is_reviewed_without_overwriting_original_result(self) -> None:
        key = make_key(111)
        for idx in (1, 2):
            source = self.input / f"dup_{idx}.pdf"
            make_pdf(source, key, "text")
            app.processar(source)
        self.assertTrue((app.SAIDA / "NF_111.pdf").exists())
        reviewed = list(app.REVISAR.glob("dup_2*.pdf"))
        self.assertEqual(len(reviewed), 1)
        self.assertTrue((app.ORIGINAIS / "dup_1.pdf").exists())
        self.assertTrue((app.ORIGINAIS / "dup_2.pdf").exists())

    def test_failed_publish_rolls_back_and_keeps_source(self) -> None:
        source = self.input / "falha_commit.pdf"
        make_pdf(source, make_key(112), "text")
        original_rename = app.os.rename
        with patch.object(app.os, "rename", side_effect=OSError("falha simulada")):
            with self.assertRaises(OSError):
                app.processar(source)
        app.os.rename = original_rename
        self.assertTrue(source.exists())
        self.assertFalse((app.SAIDA / "NF_112.pdf").exists())
        self.assertFalse(app.REGISTRO.exists())


if __name__ == "__main__":
    unittest.main(verbosity=2)
