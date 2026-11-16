# -*- mode: python ; coding: utf-8 -*-
from pathlib import Path

from PyInstaller.utils.hooks import (
    collect_data_files,
    collect_dynamic_libs,
    collect_submodules,
)


ROOT = Path(SPECPATH).resolve()

# Let PyInstaller collect Python modules and native extension dependencies.
datas = []
binaries = []
hiddenimports = []
for package in ("fitz", "zxingcpp", "PIL", "pytesseract"):
    hiddenimports += collect_submodules(package)
    if package != "fitz":
        datas += collect_data_files(package)
        binaries += collect_dynamic_libs(package)

# The external Tesseract engine and its native DLL closure are unpacked under
# _MEIPASS/runtime/tesseract in one-file mode. Language data and notices follow.
TESSERACT_ROOT = ROOT / "runtime" / "tesseract"
for source in TESSERACT_ROOT.rglob("*"):
    if not source.is_file():
        continue
    destination = str(source.parent.relative_to(ROOT))
    if source.suffix.lower() in (".exe", ".dll"):
        binaries.append((str(source), destination))
    else:
        datas.append((str(source), destination))

a = Analysis(
    [str(ROOT / "separar_nf.py")],
    pathex=[str(ROOT)],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)
# MSVCP140 is provided centrally by the offline Microsoft VC++ x86
# redistributable shipped alongside the eventual installer. Do not freeze a
# copy taken from current development Windows, which may be newer than Win7.
a.binaries = a.binaries.__class__(
    entry for entry in a.binaries
    if Path(entry[0]).name.lower() not in ("msvcp140.dll", "mupdfcpp.dll")
    or Path(entry[0]).name.lower() == "mupdfcpp.dll"
    and Path(entry[0]).parent == Path(".")
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name="SeparadorNF",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
