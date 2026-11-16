# Separador de Notas

Aplicativo para identificar chaves de acesso em PDFs de notas fiscais e organizar os documentos.

## Releases

Há duas variantes planejadas/distribuídas em Releases:

- **Geral**: executável para Windows atual.
- **Win7 x86**: executável 32 bits destinado ao Windows 7 SP1 x86. O usuário confirmou que o executável final dessa variante funcionou no computador Windows 7 de destino.

Baixe a variante correspondente em [Releases](https://github.com/Atepux/Separador-de-Notas/releases). Não é necessário instalar Python no computador de destino.

## Código-fonte

O arquivo Separador-de-Notas-Source.zip contém as duas árvores de código, scripts de compilação, especificações PyInstaller, documentação e testes sintéticos. Não contém PDFs de produção, logs locais ou ambientes virtuais.

## Licença

O código do projeto é distribuído sob GNU AGPL v3.0; consulte LICENSE. As bibliotecas e componentes empacotados têm licenças próprias, incluídas ou descritas no pacote de fontes.

## Aviso de dependências do build Win7

A auditoria técnica das DLLs do runtime Tesseract está em documentacao/THIRD_PARTY_LICENSE_AUDIT.md dentro do pacote de fontes. Ela registra lacunas de proveniência e notices para algumas DLLs, incluindo JBIG-KIT, LZO e runtimes GCC. A licença do projeto não substitui os termos de terceiros. Não foi comprovada autorização de redistribuição comercial para cada componente de terceiros; consulte os avisos antes de redistribuir os binários.

## Dados

O programa trabalha com PDFs e pode organizá-los em pastas de entrada, processados, revisão e originais. Faça cópias de segurança dos documentos fiscais antes de utilizar.
