# Reconstrução

## Versão Geral
Use Windows e Python compatível com o fonte. O build geral usa `versoes/geral/gerar_exe.bat` e `SeparadorNF.spec`. Revise caminhos/opções para o ambiente, instale as dependências definidas pelo projeto e execute os testes sintéticos antes do build.

## Windows 7 SP1 x86
Ambiente histórico fixado:
- CPython 3.8.10 x86
- PyMuPDF 1.23.26 e PyMuPDFb 1.23.22
- zxing-cpp 2.2.0
- Pillow 10.4.0
- pytesseract 0.3.13
- PyInstaller 4.10

Pins: `versoes/win7-x86/requirements-win7-x86.lock.txt`. Use venv isolado CPython 3.8 x86 e instale somente wheels win32 compatíveis, sem compilar extensões inadvertidamente.

1. Criar/ativar o venv CPython 3.8 x86.
2. Instalar o lock e verificar wheels.
3. Obter Tesseract x86 e os modelos `por`/`eng` conforme `documentacao/PROVENANCE.md`; conferir hashes e notices.
4. Rodar `test_ocr_synthetic.py` e `diagnostico_win7.ps1`.
5. Gerar com `gerar_exe.bat` ou `compile.cmd`; o instalador NSIS está em `SeparadorNF.nsi`.

O clone preserva fontes, pins, scripts e proveniência, mas não contém wheelhouse, runtime Tesseract, modelos grandes ou DLLs. A reconstrução depende de obter os componentes identificados e não é totalmente offline a partir do clone.

## Limitações
- Sem teste em instalação limpa Windows 7 SP1 x86 neste ambiente.
- `documentacao/THIRD_PARTY_LICENSE_AUDIT.md` mantém pendências para DLLs Tesseract, PyMuPDF/MuPDF e redistribuição Microsoft. Não considerar os binários liberados para redistribuição comercial até resolver.
- Releases não substituem os fontes nem provam reprodutibilidade exata.
