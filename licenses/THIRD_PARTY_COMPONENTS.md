# Inventário de componentes e avisos de terceiros

Este inventário distingue licenças confirmadas para os pacotes Python e OCR de componentes cuja licença de redistribuição dos binários ainda não foi comprovada. Não é autorização para distribuição comercial.

## Pacotes com licença identificada

| Componente | Versão | Licença | Aviso/texto |
|---|---:|---|---|
| CPython x86 | 3.8.10 | Python Software Foundation License | `Python-PSF-LICENSE.txt` |
| PyMuPDF / MuPDF | 1.23.26 / PyMuPDFb 1.23.22 | AGPL-3.0 ou comercial Artifex | `GNU-AGPL-3.0.txt`; `PyMuPDF-COPYING-AGPL.txt` no wheel é apenas o identificador da licença |
| Pillow | 10.4.0 | HPND | `Pillow-LICENSE.txt` |
| zxing-cpp | 2.2.0 | Apache-2.0 | `zxing-cpp-LICENSE-Apache-2.0.txt` |
| pytesseract | 0.3.13 | Apache-2.0 | `pytesseract-LICENSE.txt` |
| Tesseract | 5.3.0.20221222 x86 | Apache-2.0 | `Tesseract-Apache-2.0.txt`, `AUTHORS-Tesseract.txt` |
| tessdata_fast `por` e `eng` | commit `87416418657359cb625c412a48b6e1d6d41c29bd` | Apache-2.0 | `Tesseract-Apache-2.0.txt` e licença no repositório `runtime/tesseract` |
| PyInstaller | 4.10 | GPL-2.0-or-later com exceção de bootloader | `PyInstaller-COPYING.txt` |
| NSIS | 3.10 | NSIS COPYING / componentes conforme pacote | `NSIS-COPYING.txt` |

## DLLs nativas incluídas no runtime Tesseract

Todas as DLLs abaixo são PE x86, mas o pacote UB Mannheim só trouxe a licença principal do Tesseract; não há arquivo de notices que associe cada binário à versão/origem/licença individual. A distribuição dessas DLLs está pendente de verificação upstream e análise das obrigações de atribuição/fonte:

`iconv.dll`, `libarchive-13.dll`, `libbz2-1.dll`, `libcurl-4.dll`, `libgcc_s_dw2-1.dll`, `libgcc_s_sjlj-1.dll`, `libgif-7.dll`, `libidn2-0.dll`, `libintl-8.dll`, `libjbig-2.dll`, `libjpeg-8.dll`, `liblept-5.dll`, `liblz4-1.dll`, `liblzma-5.dll`, `liblzo2-2.dll`, `libnghttp2-14.dll`, `libopenjp2.dll`, `libpng16-16.dll`, `libstdc++-6.dll`, `libtesseract-5.dll`, `libtiff-5.dll`, `libunistring-2.dll`, `libwebp-7.dll`, `libwinpthread-1.dll`, `libxml2-2.dll`, `libzstd-1.dll`, `zlib1.dll`.

Ver proveniência e hashes em `runtime/tesseract/PROVENANCE.md` e `runtime/tesseract/SHA256SUMS.txt`.

## Componentes Microsoft

O pacote `VC_redist.x86.14.28.29914.exe` possui assinatura Authenticode Microsoft válida e SHA-256 `14563755AC24A874241935EF2C22C5FCE973ACB001F99E524145113B2DC638C1`. A redistribuição está sujeita aos termos de Visual Studio aplicáveis; a autorização do distribuidor não foi comprovada. Não redistribuir até revisar/confirmar esses termos. O pacote contém o próprio texto/licença aplicável ao instalador.

## Condições de release ainda pendentes

1. Obter licença comercial Artifex para PyMuPDF/MuPDF **ou** aprovar formalmente a distribuição do aplicativo e seu código-fonte sob AGPL-3.0, cumprindo todas as obrigações.
2. Coletar e verificar os notices e termos de redistribuição para cada uma das 27 DLLs nativas listadas.
3. Confirmar elegibilidade para redistribuir o VC++ Runtime pelos termos Microsoft.

Até esses pontos serem resolvidos, esta pasta é um inventário técnico de licenças e pendências; ela não certifica o pacote para distribuição comercial.
