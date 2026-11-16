# Separador de Notas

**Separe, identifique e renomeie automaticamente notas fiscais em PDF.**

![Python](https://img.shields.io/badge/Python-Automação-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-Desktop-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![OCR](https://img.shields.io/badge/OCR-Tesseract-008080?style=for-the-badge)
![Licença](https://img.shields.io/badge/Licença-AGPL_v3.0-blue?style=for-the-badge)

---

## Sobre o programa

O **Separador de Notas** é um aplicativo desenvolvido para automatizar a separação e organização de notas fiscais contidas em arquivos PDF.

Imagine receber **um único PDF contendo dezenas ou centenas de notas fiscais, todas juntas e misturadas**, sem qualquer organização. Separar manualmente cada documento, identificar seu número e salvar individualmente pode consumir bastante tempo.

É exatamente esse trabalho que o Separador de Notas busca automatizar.

O programa analisa o PDF, identifica cada nota fiscal, separa suas páginas e gera **arquivos PDF individuais, nomeados automaticamente com o número da respectiva nota fiscal**.

O processamento contempla tanto PDFs digitais, com texto selecionável, quanto documentos digitalizados por scanner, utilizando reconhecimento óptico de caracteres (OCR) quando necessário.

### Principais funcionalidades

- **Separação automática:** transforma um PDF com várias notas fiscais em arquivos individuais.
- **Identificação de notas:** analisa os documentos para reconhecer as informações necessárias à separação.
- **Renomeação automática:** salva cada PDF com o número da respectiva nota fiscal.
- **Suporte a PDFs digitais:** processa documentos que contêm texto selecionável.
- **Suporte a PDFs escaneados:** utiliza OCR para reconhecer informações em documentos digitalizados.
- **Tratamento de arquivos misturados:** permite processar notas reunidas em um mesmo PDF, sem exigir organização prévia.
- **Organização dos resultados:** facilita a localização e a conferência dos documentos separados.
- **Execução independente:** funciona por executável Windows, sem exigir instalação do Python.

---

## Como funciona

O funcionamento é simples: o usuário fornece um PDF contendo várias notas fiscais e o programa realiza o trabalho de identificação, separação e renomeação.

### Exemplo prático

**Arquivo de entrada:**

`Notas_Fiscais_Mes.pdf`

Contendo:

```text
Notas_Fiscais_Mes.pdf
│
├── Nota Fiscal nº 1258
├── Nota Fiscal nº 3489
├── Nota Fiscal nº 1025
├── Nota Fiscal nº 7841
└── Nota Fiscal nº 5623
```

**Resultado esperado após o processamento:**

```text
Notas_Separadas/
│
├── 1258.pdf
├── 3489.pdf
├── 1025.pdf
├── 7841.pdf
└── 5623.pdf
```

Cada arquivo gerado corresponde à nota fiscal identificada, preservando as páginas pertencentes ao respectivo documento.

### Etapas do processamento

**1. Leitura do PDF**

O aplicativo recebe o arquivo contendo diversas notas fiscais reunidas.

**2. Identificação dos documentos**

Analisa o conteúdo das páginas para identificar as notas fiscais e suas informações.

**3. Reconhecimento de texto**

Em PDFs digitais, utiliza o texto disponível no documento. Em PDFs escaneados, utiliza OCR para reconhecer as informações necessárias.

**4. Separação das notas**

Identifica os limites dos documentos e separa as páginas correspondentes a cada nota fiscal.

**5. Renomeação automática**

Os arquivos individuais são nomeados utilizando o número da respectiva nota fiscal.

**6. Organização e conferência**

Os documentos são disponibilizados para utilização, enquanto os casos que não puderem ser identificados adequadamente podem exigir revisão.

---

## Como utilizar

### 1. Baixe o programa

Acesse a página de downloads:

**[Baixar Separador de Notas — GitHub Releases](https://github.com/Atepux/Separador-de-Notas/releases)**

Escolha a versão compatível com seu Windows.

### 2. Prepare o PDF

Tenha disponível o arquivo PDF contendo as notas fiscais que deseja separar.

O arquivo pode conter documentos digitais ou páginas escaneadas.

### 3. Execute o aplicativo

Abra o executável do Separador de Notas.

Não é necessário instalar Python no computador de destino.

### 4. Selecione o arquivo

Utilize a interface do programa para indicar o PDF que será processado.

### 5. Inicie a separação

Execute o processamento e aguarde a identificação, separação e renomeação dos documentos.

### 6. Confira os arquivos gerados

Ao finalizar, verifique os PDFs individuais e confira os documentos que eventualmente necessitem de revisão.

**Observação:** a qualidade da digitalização pode influenciar o reconhecimento de informações em PDFs escaneados.

---

## Versões disponíveis

O projeto disponibiliza duas variantes na seção Releases.

| Versão | Compatibilidade | Descrição |
|---|---|---|
| **Geral** | Windows atual | Executável destinado aos sistemas Windows modernos |
| **Win7 x86** | Windows 7 SP1 de 32 bits | Versão específica para computadores Windows 7 x86 |

A variante **Win7 x86** teve seu funcionamento confirmado no computador Windows 7 de destino.

Ambas são distribuídas como executáveis independentes, sem necessidade de instalação do Python.

**[Acessar versões disponíveis](https://github.com/Atepux/Separador-de-Notas/releases)**

---

## Organização dos arquivos

O aplicativo pode trabalhar com pastas destinadas às diferentes etapas do processamento.

| Pasta | Finalidade |
|---|---|
| **Entrada** | Arquivos PDF originais a serem processados |
| **Processados** | Notas fiscais identificadas e separadas |
| **Revisão** | Documentos que exigem conferência |
| **Originais** | Preservação dos arquivos de origem |

A estrutura efetiva depende da configuração e da versão utilizada.

Recomenda-se manter cópias de segurança dos PDFs originais antes de executar o processamento.

---

## Tecnologias utilizadas

O Separador de Notas utiliza tecnologias de automação e processamento de documentos.

| Tecnologia | Aplicação |
|---|---|
| Python | Desenvolvimento do aplicativo |
| Processamento de PDF | Leitura, análise e separação de páginas |
| Tesseract OCR | Reconhecimento de texto em documentos escaneados |
| PyInstaller | Geração dos executáveis Windows |
| Git e GitHub | Versionamento e distribuição |

---

## Código-fonte

O pacote `Separador-de-Notas-Source.zip` disponibiliza os arquivos necessários para consulta, manutenção e desenvolvimento do projeto.

O pacote contém:

- Duas árvores de código.
- Scripts de compilação.
- Especificações PyInstaller.
- Documentação técnica.
- Testes sintéticos.

Não contém PDFs de produção, logs locais ou ambientes virtuais.

---

## Licença

O código-fonte é distribuído sob a licença **GNU Affero General Public License v3.0 (AGPL-3.0)**.

Consulte o arquivo `LICENSE` para conhecer os termos completos.

As bibliotecas e componentes de terceiros possuem licenças próprias, que devem ser observadas independentemente da licença principal do projeto.

### Dependências da versão Windows 7

A auditoria técnica das DLLs do runtime Tesseract está documentada em:

`documentacao/THIRD_PARTY_LICENSE_AUDIT.md`

O documento registra lacunas de proveniência e avisos de licenciamento relacionados a componentes como JBIG-KIT, LZO e runtimes GCC.

Não foi comprovada autorização de redistribuição comercial para todos os componentes de terceiros. Consulte a documentação e os respectivos avisos antes de redistribuir os binários.

---

## Segurança e recomendações

- Mantenha uma cópia dos documentos fiscais originais.
- Confira os números das notas fiscais identificadas.
- Revise os documentos que apresentarem problemas de reconhecimento.
- Utilize arquivos digitalizados com boa qualidade sempre que possível.
- Evite compartilhar documentos fiscais com pessoas não autorizadas.

O reconhecimento automático depende da legibilidade dos documentos e das informações presentes nos arquivos.

---

## Objetivo do projeto

O **Separador de Notas** foi criado para eliminar o trabalho repetitivo de abrir um PDF com diversas notas fiscais, localizar manualmente cada documento, separar suas páginas e salvar os arquivos individualmente.

A proposta é transformar esse processo em uma operação automatizada, oferecendo **mais rapidez, organização e produtividade às rotinas contábeis, fiscais e administrativas**.

---

**Separador de Notas**

*De um PDF com várias notas fiscais para arquivos individuais, identificados e organizados automaticamente.*
