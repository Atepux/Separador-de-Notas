# Relatório de finalização técnica — Separador de Notas Win7 x86

Data: 11/11/2026

## Estado da entrega

- Executável final de teste gerado: `dist-final/SeparadorNF.exe`.
- Instalador NSIS único: **não gerado**. O setup e o ZIP portátil NSIS 3.10 foram verificados por hash oficial; setup sem Authenticode e todos os executáveis NSIS testados no host falham com “Realocação Inválida da DLL do Sistema”. Tentativas de baixar os ZIPs 3.11/3.12/3.13 devolveram HTML com hash divergente, que foi preservado com extensão `.html` e nunca executado. O endpoint SourceForge falhou na transferência mesmo após tentativa pelo mirror indicado na página oficial. Não alterei DLLs do host nem contornei a proteção. Corrigi o `OutFile` para o nome solicitado e preparei o script privado `tools/build_installer_private.ps1` e o procedimento `BUILD_NSIS_PRIVADO.md`; ainda não compilaram o instalador.
- Compatibilidade com Windows 7: **preparada para Windows 7 SP1 x86, não validada no sistema real**. Não há VM nem máquina Windows 7 disponível.
- Distribuição comercial: ainda não liberada; veja as pendências de licença em `TERCEIROS_E_LICENCAS.md`.

## Aplicativo

O modo congelado mantém os recursos imutáveis dentro do one-file e direciona PDFs, saídas, registros e logs para `%LOCALAPPDATA%\Separador de Notas`, evitando escrita em `Program Files`. O processo gera saídas temporárias, só publica o lote completo depois de preparar os PDFs e o registro e tenta reverter as saídas em caso de falha. O original só é movido após o commit; em falha, é mantido e a rotina principal o encaminha integralmente para `revisar`.

A ordem permanece barcode (`zxing-cpp`) antes do OCR (`Tesseract` por `pytesseract`). O OCR usa modelos `por` e `eng`, pré-processamento Pillow, variantes de contraste/limiarização e rotações leves. A chave de 44 dígitos é validada pelo dígito verificador. Páginas sem chave vão para revisão se iniciarem um grupo ou são anexadas à nota precedente como continuação. Chaves repetidas seguem para revisão sem sobrescrever a saída anterior. O modo `--self-check` valida PyMuPDF, Pillow, zxing-cpp, o mecanismo/modelos Tesseract e gravação no diretório de dados.

## Versões e artefatos

Ambiente virtual isolado: CPython 3.8.10 x86. Pacotes principais: PyMuPDF 1.23.26, PyMuPDFb 1.23.22, zxing-cpp 2.2.0, Pillow 10.4.0, pytesseract 0.3.13 e PyInstaller 4.10. Dependências de build registradas por `pip freeze` incluem altgraph 0.17.5, packaging 26.2, pefile 2024.8.26, pyinstaller-hooks-contrib 2026.10, pywin32-ctypes 0.2.3, importlib-metadata 8.5.0 e zipp 3.20.2. `pip check`: sem dependências quebradas.

| Arquivo | Tamanho | SHA-256 / integridade |
|---|---:|---|
| `dist-final/SeparadorNF.exe` | 92.118.779 bytes | `85686AE30886559A316A6D8D446D24731DBB39152485E0E0BD15EDD1AF854577` |
| `vendor/VC_redist.x86.14.28.29914.exe` | 14.327.344 bytes | `14563755AC24A874241935EF2C22C5FCE973ACB001F99E524145113B2DC638C1`; assinatura Authenticode válida, Microsoft Corporation |
| `toolchain/nsis-3.10-setup.exe` | — | `4313D352E0DAFD1F22B6517126A655CAE3B444FA758D2845EDDFBE72F24F7BDD`; hash confere com a página oficial; sem Authenticode |
| `toolchain/nsis-3.10.zip` | — | `FCDCE3229717A2A148E7CDA0AB5BDB667F39D8FB33EDE1DA8DABC336BD5AD110`; hash confere com a página oficial |
| Instalador offline NSIS | — | Não gerado; downloads alternativos retornaram páginas HTML com hashes divergentes |

O executável é PE x86 (`Machine 0x014c`). A análise do archive encontrou 74 PE internos, todos x86, e 423 arestas de importação. O inventário e a resolução estática por componente estão em `DEPENDENCIAS_PE_FINAL.md`. Não foram encontrados imports desconhecidos; permanecem dependências externas esperadas de UCRT (`api-ms-win-crt-*`) e `MSVCP140.dll`. Imports dinâmicos, compatibilidade de exports do Windows 7 e o carregador do SO precisam de validação em Windows 7 real.

O Tesseract x86 contém 27 DLLs nativas listadas em `runtime/tesseract/PROVENANCE.md`; o executável e a cadeia de DLLs do pacote Mannheim foram verificados como PE x86. Tesseract é 5.3.0.20221222; modelos `eng`/`por` do repositório `tessdata_fast` commit `87416418657359cb625c412a48b6e1d6d41c29bd`. Os modelos e DLLs têm hashes em `runtime/tesseract/SHA256SUMS.txt`.

## Testes executados

- 12 testes sintéticos no Python x86: todos passaram (chaves e DV, barcode antes do OCR, PDF com texto, OCR legível, baixa resolução, inclinação/contraste, inválida em revisar, falha do Tesseract, agrupamento de páginas, duplicidade, rollback e self-check).
- Build congelado: `--self-check` passou no Windows de desenvolvimento.
- Build congelado sem Python exposto no `PATH`: `--self-check` passou com `PATH=C:\Windows\System32;C:\Windows` e `PYTHONHOME/PYTHONPATH` vazios.
- Execução funcional do one-file: PDF sintético Code128 gerou `processadas/NF_901.pdf`; PDF sintético escaneado gerou `processadas/NF_902.pdf`; originais foram movidos para `originais`. Dados foram isolados sob `validation-run-final`.
- Diagnóstico PowerShell foi analisado sintaticamente e executado no host atual. Detectou corretamente Windows 10/arquitetura AMD64 como fora do alvo, identificou runtime presente e observou o executável vivo; o diagnóstico gravou o relatório em área de usuário gravável.
- `pip check`: passou.
- Instalação/desinstalação NSIS: não testáveis, pois não foi possível obter e iniciar um compilador NSIS válido neste host. Os 18 arquivos referenciados por `File` existem e o destino declarado foi conferido estaticamente. O script de build privado passou pelo parser do PowerShell.

## Pré-requisitos e instalador candidato

O fonte `installer/SeparadorNF.nsi` implementa destino x86, verificação de Windows 7 SP1, inspeção dos 13 API sets CRT importados e `ucrtbase.dll`, verificação de registro e versão de `MSVCP140.dll`, execução condicionada do redistribuível Microsoft offline, verificação posterior, log, staging/retomada por RunOnce quando o redistribuível retornar 3010, self-check antes/depois de copiar o aplicativo e preservação de dados durante upgrade/desinstalação. O redistribuível VC++ inclui UCRT inicial quando necessário segundo a documentação Microsoft; no Windows 7 a atualização KB2999226 exige SP1 e pode exigir reinicialização. O instalador candidato não executa KB/MSU separado: rechecaria os arquivos UCRT depois do redistribuível e bloquearia se ainda faltassem.

O fonte precisa ser compilado e revisto por um NSIS válido. A causa exata do erro no host não foi determinada: CIM e leitura do log de eventos foram negados pelo ambiente. O sistema reporta Windows 10 Pro build 26300, arquitetura AMD64; `makensis.exe` principal e cópia em `Bin`, além de `makensisw.exe`, exibem a mesma realocação inválida. A análise PE de três executáveis x86 registrou ImageBase 0x400000 e diretório de relocação vazio; o `makensis.exe` raiz importa apenas KERNEL32/USER32 e o executável em `Bin` importa também MSVCP60, MSVCRT e DLLs de sistema/`zlib1.dll`. Essa evidência não basta para atribuir a falha a um conflito específico.

Foi criado um processo privado para obter e validar um ZIP oficial em outra máquina Windows, compilar e devolver o artefato com hashes: `BUILD_NSIS_PRIVADO.md` e `tools/build_installer_private.ps1`. Esse caminho ainda requer execução em máquina de compilação privada e testes de instalação/desinstalação. O instalador não deve ser tratado como release.

## Limitações e bloqueios de release

1. **PyMuPDF/MuPDF:** a wheel se identifica como AGPL-3.0 ou comercial Artifex. Não foi encontrada licença comercial, nem autorização para publicar o código completo sob AGPL. O texto da licença foi incluído em `licenses/GNU-AGPL-3.0.txt`; isso não satisfaz por si só as obrigações da AGPL.
2. **DLLs de terceiros do Tesseract:** o pacote do instalador Mannheim não contém notices completos por DLL. A proveniência/hashes foram registrados, mas é preciso verificar as 27 licenças upstream e recolher os avisos/fontes que forem exigidos.
3. **Microsoft VC++:** a assinatura e o hash do pacote foram confirmados, mas não há comprovação de que o distribuidor tenha direito contratual de redistribuição segundo os termos aplicáveis do Visual Studio.
4. **NSIS:** o setup e ZIP 3.10 correspondem aos hashes oficiais. As tentativas 3.11/3.12/3.13 não baixaram ZIPs válidos: as respostas eram HTML e não conferiam com os hashes publicados. O setup, os dois `makensis.exe` disponíveis e `makensisw.exe` falham neste host com o erro de realocação. Não há instalador compilado; instalação, retomada e desinstalação não puderam ser testadas.
5. **Windows 7:** não testado. O teste no host moderno não comprova Windows 7, KB/UCRT, estabilidade do Tesseract 5.3 ou compatibilidade das APIs do one-file.

## Arquivos desta etapa

- Aplicativo: `separar_nf.py`, `SeparadorNF.spec`, `gerar_exe.bat`.
- Testes: `tests/test_ocr_synthetic.py`.
- Scanner PE: `tools/scan_pe_dependencies.py`.
- Relatórios: `DEPENDENCIAS_PE_FINAL.md`, `diagnostico_win7.ps1`, este arquivo.
- Instalador candidato: `installer/SeparadorNF.nsi`, `installer/compile.cmd`; build privado: `BUILD_NSIS_PRIVADO.md`, `tools/build_installer_private.ps1`.
- Manual e avisos: `MANUAL.txt`, `TERCEIROS_E_LICENCAS.md`, `licenses/`.
- Backup pré-alteração desta etapa: `backups/before-nsis-20261111-162303/`.
