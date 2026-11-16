# Separador de Notas

Aplicativo para localizar chaves de acesso em PDFs de notas fiscais e separar/organizar documentos.

## Releases
- **Geral**: build para Windows atuais.
- **Win7 x86**: build 32 bits preparado para Windows 7 SP1 x86. O usuário informou que o executável publicado funcionou em seu computador Windows 7; não houve teste de instalação limpa neste ambiente.

Baixe o artefato correspondente em [Releases](https://github.com/Atepux/Separador-de-Notas/releases). O computador de destino não precisa de Python.

## Código-fonte
- [Versão Geral](source/versoes/geral/)
- [Versão Win7 x86](source/versoes/win7-x86/)
- [Reconstrução e dependências](source/RECONSTRUIR.md)
- [Documentação técnica](source/documentacao/)
- [Licenças](source/licenses/)

`Separador-de-Notas-Source.zip` permanece como snapshot. As pastas acima são o fonte organizado. PDFs fiscais, logs, ambientes virtuais e caches não fazem parte do fonte publicado.

## Licença e terceiros
O código usa GNU AGPL v3.0 (consulte `LICENSE`). Dependências têm licenças próprias. A auditoria Win7 registra pendências de redistribuição para DLLs Tesseract, PyMuPDF/MuPDF e runtime Microsoft; notices não equivalem a autorização comercial. Consulte `source/documentacao/THIRD_PARTY_LICENSE_AUDIT.md` antes de redistribuir binários.
