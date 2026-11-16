# Auditoria preliminar de licenças — runtime Tesseract

Data: 2026-11-16. Escopo: runtime x86 em runtime/tesseract e o código do Separador de Notas Win7.

> **Status: pendente para redistribuição pública dos binários.** Inventário técnico, não parecer jurídico nem prova de autorização comercial. A licença AGPL-3.0 autorizada pelo titular cobre o código próprio; ela não substitui termos de terceiros.

## Evidência local

PROVENANCE.md registra UB Mannheim Tesseract 5.3.0.20221222 x86, hash do setup e PE machine 0x014C em EXEs/DLLs. A saída tesseract.exe --version identifica Tesseract 5.3.0.20221222, Leptonica 1.78.0 e versões de algumas bibliotecas. Várias DLLs não contêm versão PE útil. O pacote contém licença Apache do Tesseract e tessdata_fast, mas não notices individuais para todas as DLLs.

## Inventário das 27 DLLs

| DLL | Licença upstream conhecida | Evidência/pendência nesta cópia |
|---|---|---|
| iconv.dll | GNU libiconv LGPL | versão/build e notice ausentes |
| libarchive-13.dll | New BSD | build e notice ausentes |
| libbz2-1.dll | bzip2 BSD-style | build e notice ausentes |
| libcurl-4.dll | curl license MIT-derived; features podem adicionar termos | reporta 7.77.0-DEV; configuração/notices não comprovados |
| libgcc_s_dw2-1.dll | GCC Runtime Library Exception conforme build | build e notices ausentes |
| libgcc_s_sjlj-1.dll | GCC Runtime Library Exception conforme build | build e notices ausentes |
| libgif-7.dll | GIFLIB/X Consortium-style | build e notice ausentes |
| libidn2-0.dll | LGPLv3+ ou GPLv2+ | reporta 2.0.4; licença escolhida/build não comprovado |
| libintl-8.dll | gettext/libintl LGPL | metadado aponta 0.19.8.1; notice ausente |
| libjbig-2.dll | JBIG-KIT GPL; opção comercial upstream | versão e variante da GPL não comprovadas |
| libjpeg-8.dll | libjpeg-turbo BSD-style | reporta 1.5.3; notice ausente |
| liblept-5.dll | Leptonica BSD-2-Clause | reporta 1.78.0; notice ausente |
| liblz4-1.dll | LZ4 BSD-2-Clause | build e notice ausentes |
| liblzma-5.dll | XZ/liblzma tem termos por arquivo/componente | metadado aponta 5.2.3; identificar licença exata e notice |
| liblzo2-2.dll | LZO 2.x GPLv2+; opção comercial | versão e notice desta cópia não comprovados |
| libnghttp2-14.dll | nghttp2 MIT | reporta 1.31.0; notice ausente |
| libopenjp2.dll | OpenJPEG BSD-2-Clause | reporta 2.3.0; notice ausente |
| libpng16-16.dll | libpng license permissiva com aviso | reporta 1.6.34; notice ausente |
| libstdc++-6.dll | GPLv3 com GCC Runtime Library Exception 3.1, se condições satisfeitas | build e exceção aplicável não comprovados |
| libtesseract-5.dll | Apache-2.0 | Tesseract 5.3.0.20221222; licença incluída |
| libtiff-5.dll | libtiff license BSD-like | strings apontam TIFF 4.0.9; notice ausente |
| libunistring-2.dll | LGPLv3+ ou GPLv2+ | metadado aponta 0.9.6; variante/notice ausente |
| libwebp-7.dll | libwebp BSD-style | reporta 0.6.1; notice ausente |
| libwinpthread-1.dll | mingw-w64 MIT e trechos BSD-derived | build e avisos exatos ausentes |
| libxml2-2.dll | libxml2 MIT | strings apontam 2.9.4; notice ausente |
| libzstd-1.dll | Zstandard BSD-3-Clause OR GPL-2.0 | reporta 1.4.5; licença/notice a acompanhar não confirmado |
| zlib1.dll | zlib license | reporta 1.2.11; notice ausente |

Licenças acima são identificação upstream provável; não certificam origem ou termos do binário local.

## Impedimentos materiais para publicar executáveis

1. JBIG-KIT: a página upstream informa licença GPL, alerta que linking dinâmico ou estático pode criar obra combinada GPL e oferece licença comercial. A versão e a licença exata desta DLL precisam ser comprovadas e compatibilizadas com o programa AGPL-3.0.
2. LZO: versão da DLL e notice precisam ser identificados. Upstream informa GPLv2+ para LZO 2.10 e opção comercial; aplicabilidade à cópia local não provada.
3. GCC runtimes: faltam versão/build e notices que demonstrem a aplicação da GCC Runtime Library Exception.
4. As demais DLLs carecem, em geral, de versão exata, fonte de build e notices requeridos para redistribuição.
5. O pacote Chocolatey/UB Mannheim não substitui a auditoria e os avisos individualizados das dependências compiladas.

## Fontes upstream

- Tesseract Apache-2.0: https://github.com/tesseract-ocr/tesseract/blob/main/LICENSE
- tessdata_fast Apache-2.0: https://github.com/tesseract-ocr/tessdata_fast
- Leptonica: https://github.com/DanBloomberg/leptonica
- JBIG-KIT: https://www.cl.cam.ac.uk/~mgk25/jbigkit/
- LZO: https://www.oberhumer.com/opensource/lzo/
- GCC Runtime Library Exception: https://www.gnu.org/licenses/gcc-exception-3.1.html
- GNU libiconv: https://www.gnu.org/software/libiconv/
- libarchive: https://www.libarchive.org/
- bzip2: https://sourceware.org/bzip2/
- curl: https://curl.se/docs/copyright.html
- libidn2/libunistring: https://www.gnu.org/software/libidn/#Licensing e https://www.gnu.org/software/libunistring/#Licensing
- libjpeg-turbo: https://libjpeg-turbo.org/
- GIFLIB: https://giflib.sourceforge.net/
- libtiff: https://gitlab.com/libtiff/libtiff/-/blob/master/LICENSE.md
- LZ4: https://github.com/lz4/lz4/blob/dev/LICENSE
- XZ Utils: https://github.com/tukaani-project/xz/blob/master/COPYING
- nghttp2: https://github.com/nghttp2/nghttp2/blob/master/COPYING
- OpenJPEG: https://github.com/uclouvain/openjpeg/blob/master/LICENSE
- libpng: https://github.com/pnggroup/libpng/blob/libpng16/LICENSE
- libwebp: https://github.com/webmproject/libwebp/blob/main/COPYING
- libxml2: https://github.com/GNOME/libxml2/blob/master/Copyright
- Zstandard: https://github.com/facebook/zstd/blob/dev/LICENSE
- zlib: https://zlib.net/zlib_license.html
- PyMuPDF: https://pymupdf.io/licensing

## Ação antes da publicação

Obter do fornecedor do bundle um SBOM/manifesto com versões, origem, licenças e notices de todas as DLLs, ou reconstruir o runtime a partir de fontes rastreáveis. Resolver JBIG-KIT, LZO e GCC Runtime Exception. Não publicar os executáveis enquanto persistirem essas pendências. Esta auditoria não é aconselhamento jurídico.
