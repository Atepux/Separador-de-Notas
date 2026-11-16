# Plano de validação em Windows 7 SP1 x86

## Estado e segurança

O executável atual em `dist-win7-test\SeparadorNF.exe` é um artefato de teste e deve ser preservado. Estes procedimentos não instalam runtimes nem copiam DLLs do computador de desenvolvimento. A validação requer uma VM limpa, snapshot antes de cada cenário e rede desconectada nos testes offline.

## Preparar a VM

1. Criar uma VM com Windows 7 SP1 **32 bits**, sem Python, sem acesso à rede e com snapshot limpo. Registrar edição, idioma, Service Pack, atualizações e tamanho de memória.
2. Copiar para uma pasta gravável o executável de teste, a árvore `runtime\tesseract` correspondente ao build e `diagnostico_win7.ps1`. Não instalar componentes ainda.
3. Executar PowerShell como usuário comum: `powershell.exe -ExecutionPolicy Bypass -File .\diagnostico_win7.ps1 -ExePath .\SeparadorNF.exe`.
4. Preservar o relatório, `diagnostico-exe-stdout.txt`, `diagnostico-exe-stderr.txt` e o log do aplicativo. Erros como `0xC0000135` sugerem DLL ausente; `0xC000007B` sugere arquitetura/formato incompatível. Confirmar com Process Monitor ou Dependency Walker compatível com Windows 7, se necessário; não concluir somente pelo código de saída.

## Casos de pré-requisito

Usar snapshots independentes para (A) Windows sem runtime VC++ x86 e sem UCRT/KB aplicável, (B) sistema com cada componente instalado separadamente, (C) ambos presentes. Primeiro executar apenas o diagnóstico e guardar evidências. Depois instalar **somente** o redistribuível oficial x86 e a atualização UCRT aplicável, reiniciar quando solicitado, repetir diagnóstico e inicialização. Nunca substituir arquivos de `System32` manualmente. Anotar versão exibida pelo registro e assinatura dos instaladores usados.

O teste de registro do VC++ é um indicador, não prova suficiente: a prova final é executar o app e exercitar as extensões nativas. A presença de `ucrtbase.dll` também não comprova, isoladamente, que todos os componentes UCRT estão íntegros. O Windows 7 SP1 pode requerer KB2999226 para UCRT; verificar os pré-requisitos oficiais e a condição real da VM antes de provisionar.

## Testes funcionais e sem internet

Preparar os PDFs sintéticos em ambiente de desenvolvimento usando `tests\test_ocr_synthetic.py` (nenhum documento de produção). Copiar os PDFs gerados para `entrada` na VM e testar:

| Cenário | Resultado esperado |
| --- | --- |
| Chave impressa em PDF com texto | Arquivo `NF_<numero>.pdf` em `processadas` |
| DANFE sintético escaneado legível | OCR retorna chave validada e separa |
| Código de barras sintético Code128 | Leitura por zxing-cpp antes do OCR |
| Chave com DV inválido / sem chave | Documento em `revisar`, erro registrado |
| Duas notas sintéticas no mesmo PDF | Dois PDFs separados e original movido para `originais` |
| Execução sem Python e com NIC desconectada | Inicializa e processa os mesmos fixtures |

O aplicativo monitora `entrada` em ciclos. Colocar um PDF por vez e aguardar o processamento; verificar `processadas`, `revisar`, `originais`, `registro_notas.csv` e `separador.log`. Repetir após reinicialização da VM. Esse executável não deve ser testado com PDFs reais de produção.

## Registro e aprovação

Salvar captura dos resultados, relatório PowerShell, logs, lista e versão dos redistribuíveis, estado de conectividade, hashes dos artefatos e resultado de cada cenário. Só avançar para o instalador depois de validar em VM limpa Windows 7 SP1 x86, confirmar dependências efetivas e resolver licenças de redistribuição. A execução atual em Windows mais recente não comprova compatibilidade com Windows 7.
