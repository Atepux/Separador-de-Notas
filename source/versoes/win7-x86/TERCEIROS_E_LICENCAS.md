# Dependências, versões e licenças

## Versões incluídas no build

| Componente | Versão | Licença identificada | Estado de redistribuição |
|---|---:|---|---|
| CPython | 3.8.10 x86 | Python Software Foundation License | Texto incluído; confirmar todos os componentes redistribuídos do runtime |
| PyMuPDF / MuPDF | 1.23.26 / PyMuPDFb 1.23.22 | AGPL-3.0 ou licença comercial Artifex | **Bloqueio para binário proprietário/comercial sem licença Artifex ou cumprimento integral da AGPL** |
| Pillow | 10.4.0 | HPND | Texto da distribuição incluído |
| zxing-cpp | 2.2.0 | Apache-2.0 | LICENSE da tag oficial v2.2.0 incluída; confirmar se há NOTICE adicional |
| pytesseract | 0.3.13 | Apache-2.0 | Texto incluído |
| Tesseract | 5.3.0.20221222 x86 | Apache-2.0 | Texto incluído |
| tessdata_fast `por` / `eng` | commit `87416418657359cb625c412a48b6e1d6d41c29bd` | Apache-2.0 | Texto incluído; hashes em runtime/tesseract/SHA256SUMS.txt |
| PyInstaller | 4.10 | GPL-2.0-or-later com exceção especial para bootloader | Aviso incluído; verificar exceção e distribuição final |
| Microsoft VC++ Runtime | 14.28.29914.0 x86 | Termos de redistribuição Microsoft/Visual Studio | Assinatura/hash verificados; **elegibilidade/licença do distribuidor não comprovada** |
| DLLs de terceiros da distribuição Mannheim | 27 DLLs x86 | Múltiplas licenças upstream | **Pendência: o instalador extraído não fornece avisos completos por DLL; não declarar licença resolvida** |
| NSIS | 3.10 | NSIS COPYING / termos dos componentes | Setup e ZIP oficiais obtidos e hash conferido; ZIP extraído em `toolchain`. NSIS 3.11/3.12/3.13: respostas de download HTML divergiram dos hashes oficiais e não foram executadas. Compiler indisponível por erro do loader neste host. Texto em `licenses/NSIS-COPYING.txt`. |

## Pendências que bloqueiam a distribuição comercial

1. O PyMuPDF declara dual licensing AGPL/comercial. Este projeto não tem comprovante de licença comercial Artifex nem decisão de distribuir seu código sob AGPL com as obrigações correspondentes. A cópia de `COPYING` no wheel é apenas um identificador de 18 bytes, por isso o texto AGPL oficial está em `licenses/GNU-AGPL-3.0.txt`; sua inclusão não substitui cumprir as obrigações da licença.
2. O instalador UB Mannheim traz DLLs de múltiplos projetos e não foi acompanhado por notice completo de cada biblioteca. O inventário das DLLs está em `runtime/tesseract/PROVENANCE.md`; ainda é preciso obter/validar a licença de cada origem, incluindo eventuais obrigações de atribuição, disponibilização de fontes e exceções comerciais.
3. Os termos Microsoft limitam a redistribuição do VC++ Runtime a usuários licenciados do Visual Studio, segundo os termos aplicáveis. Não foi possível comprovar que o distribuidor tem essa licença. Não distribuir o runtime sem essa confirmação.
4. O zxing-cpp tem licença Apache-2.0 no pacote, porém seu aviso/copyright upstream ainda deve ser coletado para o pacote final.
5. NSIS não foi compilado nem incorporado ao pacote. O fonte `.nsi` é candidato técnico e ainda não foi validado por compilador. Um processo privado de build está documentado em `BUILD_NSIS_PRIVADO.md`; pendências anteriores de licença seguem inalteradas.

## Textos copiados para acompanhamento

Os textos coletados estão em `licenses/`. O arquivo `GNU-AGPL-3.0.txt` veio do site oficial GNU; Tesseract/modelos e zxing-cpp usam Apache-2.0; Pillow usa seu arquivo de licença HPND; os termos de Python e PyInstaller vêm das distribuições locais; o COPYING do NSIS veio do ZIP oficial. O inventário das 27 DLLs Tesseract continua explicitamente incompleto e não deve ser tratado como liberação comercial.

## Referências oficiais

- PyMuPDF licensing: https://pymupdf.io/licensing e https://pymupdf.readthedocs.io/en/latest/about.html
- Microsoft VC++ redistribution: https://learn.microsoft.com/en-us/cpp/windows/redistributing-visual-cpp-files
- Microsoft UCRT: https://learn.microsoft.com/en-us/cpp/windows/universal-crt-deployment
- Tesseract installation/licensing: https://tesseract-ocr.github.io/tessdoc/Installation.html
- NSIS license: https://nsis.sourceforge.io/Docs/AppendixI.html
