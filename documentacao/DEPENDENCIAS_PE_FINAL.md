# Dependências PE do build de teste

Executável: `dist-final\SeparadorNF.exe`
Binários PE extraídos do archive one-file: 74

`x86/0x014c` é o alvo; módulos `api-ms-win-crt-*` dependem da UCRT do Windows.
Módulos marcados como sistema não estão empacotados e precisam existir no Windows de destino.
A inspeção estática não substitui execução no Windows 7; delay-load e LoadLibrary dinâmico podem não aparecer.

## Imports por binário e resolução

### `_asyncio.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `_bz2.pyd` — x86/0x014c
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `_ctypes.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libffi-7.dll` → empacotado: `libffi-7.dll`
- `ole32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `oleaut32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `_decimal.pyd` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-locale-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `_hashlib.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libcrypto-1_1.dll` → empacotado: `libcrypto-1_1.dll`
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `_lzma.pyd` — x86/0x014c
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `_multiprocessing.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `_overlapped.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `_queue.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `_socket.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `iphlpapi.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `_ssl.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `crypt32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libcrypto-1_1.dll` → empacotado: `libcrypto-1_1.dll`
- `libssl-1_1.dll` → empacotado: `libssl-1_1.dll`
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `fitz\_extra.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcp140.dll` → Microsoft Visual C++ Redistributable x86; validar versão/instalação
- `mupdfcpp.dll` → empacotado: `mupdfcpp.dll`, `site-packages\fitz\mupdfcpp.dll`, `site-packages\fitz_old\mupdfcpp.dll`
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `fitz\_mupdf.pyd` — x86/0x014c
- `mupdfcpp.dll` → empacotado: `mupdfcpp.dll`, `site-packages\fitz\mupdfcpp.dll`, `site-packages\fitz_old\mupdfcpp.dll`

### `libcrypto-1_1.dll` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-filesystem-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-time-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `bcrypt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `libffi-7.dll` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `libssl-1_1.dll` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-time-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libcrypto-1_1.dll` → empacotado: `libcrypto-1_1.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `mupdfcpp.dll` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-filesystem-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-time-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcp140.dll` → Microsoft Visual C++ Redistributable x86; validar versão/instalação
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `PIL\_imaging.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `gdi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `PIL\_imagingcms.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-filesystem-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-time-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `gdi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `PIL\_imagingft.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `PIL\_imagingmath.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `PIL\_imagingmorph.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `PIL\_imagingtk.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `psapi.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `PIL\_webp.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `pyexpat.pyd` — x86/0x014c
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `python38.dll` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `api-ms-win-crt-conio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-filesystem-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-locale-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-process-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-time-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `shlwapi.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
- `version.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\iconv.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libarchive-13.dll` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `bcrypt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `iconv.dll` → empacotado: `runtime\tesseract\iconv.dll`
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libbz2-1.dll` → empacotado: `runtime\tesseract\libbz2-1.dll`
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `liblz4-1.dll` → empacotado: `runtime\tesseract\liblz4-1.dll`
- `liblzma-5.dll` → empacotado: `runtime\tesseract\liblzma-5.dll`
- `liblzo2-2.dll` → empacotado: `runtime\tesseract\liblzo2-2.dll`
- `libxml2-2.dll` → empacotado: `runtime\tesseract\libxml2-2.dll`
- `libzstd-1.dll` → empacotado: `runtime\tesseract\libzstd-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `zlib1.dll` → empacotado: `runtime\tesseract\zlib1.dll`

### `runtime\tesseract\libbz2-1.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libcurl-4.dll` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `crypt32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `libidn2-0.dll` → empacotado: `runtime\tesseract\libidn2-0.dll`
- `libnghttp2-14.dll` → empacotado: `runtime\tesseract\libnghttp2-14.dll`
- `libwinpthread-1.dll` → empacotado: `runtime\tesseract\libwinpthread-1.dll`
- `libzstd-1.dll` → empacotado: `runtime\tesseract\libzstd-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `wldap32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `zlib1.dll` → empacotado: `runtime\tesseract\zlib1.dll`

### `runtime\tesseract\libgcc_s_dw2-1.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libwinpthread-1.dll` → empacotado: `runtime\tesseract\libwinpthread-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libgcc_s_sjlj-1.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libwinpthread-1.dll` → empacotado: `runtime\tesseract\libwinpthread-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libgif-7.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libidn2-0.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `libintl-8.dll` → empacotado: `runtime\tesseract\libintl-8.dll`
- `libunistring-2.dll` → empacotado: `runtime\tesseract\libunistring-2.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libintl-8.dll` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `iconv.dll` → empacotado: `runtime\tesseract\iconv.dll`
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libjbig-2.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libjpeg-8.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\liblept-5.dll` — x86/0x014c
- `gdi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `libgif-7.dll` → empacotado: `runtime\tesseract\libgif-7.dll`
- `libjpeg-8.dll` → empacotado: `runtime\tesseract\libjpeg-8.dll`
- `libopenjp2.dll` → empacotado: `runtime\tesseract\libopenjp2.dll`
- `libpng16-16.dll` → empacotado: `runtime\tesseract\libpng16-16.dll`
- `libtiff-5.dll` → empacotado: `runtime\tesseract\libtiff-5.dll`
- `libwebp-7.dll` → empacotado: `runtime\tesseract\libwebp-7.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `zlib1.dll` → empacotado: `runtime\tesseract\zlib1.dll`

### `runtime\tesseract\liblz4-1.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\liblzma-5.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\liblzo2-2.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libnghttp2-14.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libopenjp2.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libpng16-16.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `zlib1.dll` → empacotado: `runtime\tesseract\zlib1.dll`

### `runtime\tesseract\libstdc++-6.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_dw2-1.dll` → empacotado: `runtime\tesseract\libgcc_s_dw2-1.dll`
- `libwinpthread-1.dll` → empacotado: `runtime\tesseract\libwinpthread-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libtesseract-5.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libarchive-13.dll` → empacotado: `runtime\tesseract\libarchive-13.dll`
- `libcurl-4.dll` → empacotado: `runtime\tesseract\libcurl-4.dll`
- `libgcc_s_dw2-1.dll` → empacotado: `runtime\tesseract\libgcc_s_dw2-1.dll`
- `liblept-5.dll` → empacotado: `runtime\tesseract\liblept-5.dll`
- `libstdc++-6.dll` → empacotado: `runtime\tesseract\libstdc++-6.dll`
- `libwinpthread-1.dll` → empacotado: `runtime\tesseract\libwinpthread-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libtiff-5.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `libjbig-2.dll` → empacotado: `runtime\tesseract\libjbig-2.dll`
- `libjpeg-8.dll` → empacotado: `runtime\tesseract\libjpeg-8.dll`
- `liblzma-5.dll` → empacotado: `runtime\tesseract\liblzma-5.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `zlib1.dll` → empacotado: `runtime\tesseract\zlib1.dll`

### `runtime\tesseract\libunistring-2.dll` — x86/0x014c
- `iconv.dll` → empacotado: `runtime\tesseract\iconv.dll`
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libwebp-7.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libwinpthread-1.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\libxml2-2.dll` — x86/0x014c
- `iconv.dll` → empacotado: `runtime\tesseract\iconv.dll`
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `liblzma-5.dll` → empacotado: `runtime\tesseract\liblzma-5.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `zlib1.dll` → empacotado: `runtime\tesseract\zlib1.dll`

### `runtime\tesseract\libzstd-1.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libgcc_s_sjlj-1.dll` → empacotado: `runtime\tesseract\libgcc_s_sjlj-1.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\tesseract.exe` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `libarchive-13.dll` → empacotado: `runtime\tesseract\libarchive-13.dll`
- `libcurl-4.dll` → empacotado: `runtime\tesseract\libcurl-4.dll`
- `libgcc_s_dw2-1.dll` → empacotado: `runtime\tesseract\libgcc_s_dw2-1.dll`
- `liblept-5.dll` → empacotado: `runtime\tesseract\liblept-5.dll`
- `libstdc++-6.dll` → empacotado: `runtime\tesseract\libstdc++-6.dll`
- `libtesseract-5.dll` → empacotado: `runtime\tesseract\libtesseract-5.dll`
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `runtime\tesseract\zlib1.dll` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcrt.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `select.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
- `ws2_32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\fitz\mupdfcpp.dll` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-filesystem-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-time-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcp140.dll` → Microsoft Visual C++ Redistributable x86; validar versão/instalação
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `site-packages\fitz_old\mupdfcpp.dll` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-environment-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-filesystem-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-time-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-utility-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcp140.dll` → Microsoft Visual C++ Redistributable x86; validar versão/instalação
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `site-packages\pip\_vendor\distlib\t32.exe` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `shlwapi.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\pip\_vendor\distlib\t64.exe` — machine=0x8664 (verificar)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `shlwapi.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\pip\_vendor\distlib\w32.exe` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `shlwapi.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\pip\_vendor\distlib\w64.exe` — machine=0x8664 (verificar)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `shlwapi.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\PyInstaller\bootloader\Windows-32bit\run.exe` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\PyInstaller\bootloader\Windows-32bit\run_d.exe` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\PyInstaller\bootloader\Windows-32bit\runw.exe` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `comctl32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `gdi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\PyInstaller\bootloader\Windows-32bit\runw_d.exe` — x86/0x014c
- `advapi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `comctl32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `gdi32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `user32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\setuptools\cli-32.exe` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\setuptools\cli-64.exe` — machine=0x8664 (verificar)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\setuptools\cli.exe` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\setuptools\gui-32.exe` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\setuptools\gui-64.exe` — machine=0x8664 (verificar)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `site-packages\setuptools\gui.exe` — x86/0x014c
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `unicodedata.pyd` — x86/0x014c
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`

### `VCRUNTIME140.dll` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)

### `zxingcpp.cp38-win32.pyd` — x86/0x014c
- `api-ms-win-crt-convert-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-heap-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-math-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-runtime-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-stdio-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `api-ms-win-crt-string-l1-1-0.dll` → UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)
- `kernel32.dll` → módulo do Windows (validar disponibilidade/exports no Win7 SP1)
- `msvcp140.dll` → Microsoft Visual C++ Redistributable x86; validar versão/instalação
- `python38.dll` → empacotado: `python38.dll`
- `vcruntime140.dll` → empacotado: `VCRUNTIME140.dll`
