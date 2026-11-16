# Tesseract OCR bundled runtime

- Installer: UB Mannheim Tesseract 5.3.0.20221222, x86 setup.
- Source package supplied in the project: `tesseract-ocr.5.3.0.20221222.nupkg`.
- Extracted x86 setup SHA-256: `33D7824A440E1660B74DC55F10355B346A22FDBE430143F7F6885CFA3CFDF7E7`.
- That SHA-256 matches the x86 checksum recorded in the package's `tools/VERIFICATION.txt`.
- The setup PE machine is `0x014C` (x86/IA-32); extracted Tesseract EXE and DLLs were also checked as PE machine `0x014C`.
- Tesseract project license: Apache-2.0; see `LICENSE-Tesseract.txt`.
- The Chocolatey package has a wrapper license file, but the licenses for every third-party binary in the UB Mannheim bundle still require a distribution review.

## Language models

Models are from the official `tesseract-ocr/tessdata_fast` repository at commit
`87416418657359cb625c412a48b6e1d6d41c29bd` (2024-01-08). The Git blob IDs
and SHA-256 values below matched the downloaded files.

| File | Size | Git blob SHA-1 | SHA-256 |
|---|---:|---|---|
| `eng.traineddata` | 4,113,088 | `bbef4675053b5b468cdb477053e28b1c698ba08e` | `7D4322BD2A7749724879683FC3912CB542F19906C83BCC1A52132556427170B2` |
| `por.traineddata` | 1,982,756 | `e9f373e95c66b4bf557c263721ef31f78e5bc301` | `C4932B937207A9514B7514D518B931A99938C02A28A5A5A553F8599ED58B7DEB` |

The `tessdata_fast` repository uses Apache-2.0; see `LICENSE-tessdata_fast.txt`.

## Runtime import closure

The x86 `tesseract.exe` PE import closure included these 27 bundled DLLs:

`iconv.dll`, `libarchive-13.dll`, `libbz2-1.dll`, `libcurl-4.dll`,
`libgcc_s_dw2-1.dll`, `libgcc_s_sjlj-1.dll`, `libgif-7.dll`, `libidn2-0.dll`,
`libintl-8.dll`, `libjbig-2.dll`, `libjpeg-8.dll`, `liblept-5.dll`,
`liblz4-1.dll`, `liblzma-5.dll`, `liblzo2-2.dll`, `libnghttp2-14.dll`,
`libopenjp2.dll`, `libpng16-16.dll`, `libstdc++-6.dll`, `libtesseract-5.dll`,
`libtiff-5.dll`, `libunistring-2.dll`, `libwebp-7.dll`, `libwinpthread-1.dll`,
`libxml2-2.dll`, `libzstd-1.dll`, and `zlib1.dll`.

The imported operating-system modules were Windows system DLLs, including
`KERNEL32`, `MSVCRT`, `USER32`, `GDI32`, `ADVAPI32`, `WS2_32`, `CRYPT32`,
`WLDAP32`, and `BCRYPT`. The scanned imports did not name UCRT or a VC++ runtime
DLL for this Tesseract closure. This is a PE import result, not proof of
Windows 7 compatibility; dynamically loaded modules and API availability
still require execution tests on Windows 7 SP1 x86.
