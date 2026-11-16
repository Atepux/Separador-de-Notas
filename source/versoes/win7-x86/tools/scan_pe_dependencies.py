"""Lista imports PE e resolução entre os binários do PyInstaller one-file.

Execute no ambiente de desenvolvimento com pefile instalado:
  python tools/scan_pe_dependencies.py dist-win7-test/SeparadorNF.exe
"""
from __future__ import annotations

import argparse
from collections import defaultdict
from pathlib import Path

import pefile
from PyInstaller.archive.readers import CArchiveReader


WINDOWS_MODULES = {
    "advapi32.dll", "bcrypt.dll", "cfgmgr32.dll", "comctl32.dll", "comdlg32.dll",
    "crypt32.dll", "gdi32.dll", "imm32.dll", "iphlpapi.dll", "kernel32.dll", "msvcrt.dll",
    "mswsock.dll", "ncrypt.dll", "ole32.dll", "oleaut32.dll", "psapi.dll", "rpcrt4.dll",
    "secur32.dll", "setupapi.dll", "shell32.dll", "shlwapi.dll", "user32.dll",
    "version.dll", "winmm.dll", "winspool.drv", "ws2_32.dll", "wldap32.dll",
}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("exe", type=Path)
    parser.add_argument("--output", type=Path, default=Path("DEPENDENCIAS_PE_BUILD_TEST.md"))
    args = parser.parse_args()
    archive = CArchiveReader(str(args.exe))
    payloads = {}
    machines = {}
    for name in archive.contents():
        extracted = archive.extract(name)
        if not extracted or not isinstance(extracted, tuple):
            continue
        data = extracted[1]
        if not isinstance(data, bytes) or len(data) < 2 or data[:2] != b"MZ":
            continue
        try:
            pe = pefile.PE(data=data, fast_load=True)
            machine = pe.FILE_HEADER.Machine
            payloads[name] = data
            machines[name] = machine
        except pefile.PEFormatError:
            continue

    by_basename = defaultdict(list)
    imports = {}
    for name, data in payloads.items():
        pe = pefile.PE(data=data, fast_load=True)
        try:
            pe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY["IMAGE_DIRECTORY_ENTRY_IMPORT"]])
            deps = sorted({item.dll.decode("ascii", "replace").lower() for item in getattr(pe, "DIRECTORY_ENTRY_IMPORT", [])})
        except Exception:
            deps = []
        imports[name] = deps
        by_basename[Path(name.replace("\\", "/")).name.lower()].append(name)

    lines = [
        "# Dependências PE do build de teste",
        "",
        f"Executável: `{args.exe}`",
        f"Binários PE extraídos do archive one-file: {len(payloads)}",
        "",
        "`x86/0x014c` é o alvo; módulos `api-ms-win-crt-*` dependem da UCRT do Windows.",
        "Módulos marcados como sistema não estão empacotados e precisam existir no Windows de destino.",
        "A inspeção estática não substitui execução no Windows 7; delay-load e LoadLibrary dinâmico podem não aparecer.",
        "",
        "## Imports por binário e resolução",
        "",
    ]
    for name in sorted(payloads, key=str.lower):
        machine = machines[name]
        arch = "x86/0x014c" if machine == 0x14C else f"machine=0x{machine:04x} (verificar)"
        lines.append(f"### `{name}` — {arch}")
        for dep in imports[name]:
            packaged = by_basename.get(dep, [])
            if packaged:
                resolution = "empacotado: " + ", ".join(f"`{p}`" for p in packaged)
            elif dep.startswith("api-ms-win-crt-") or dep.startswith("ucrtbase"):
                resolution = "UCRT do Windows (KB2999226 aplicável ao Windows 7 SP1)"
            elif dep.startswith(("msvcp", "vcruntime")):
                resolution = "Microsoft Visual C++ Redistributable x86; validar versão/instalação"
            elif dep in WINDOWS_MODULES or dep.startswith("api-ms-win-"):
                resolution = "módulo do Windows (validar disponibilidade/exports no Win7 SP1)"
            else:
                resolution = "não localizado no archive nem na lista de módulos de sistema; investigar"
            lines.append(f"- `{dep}` → {resolution}")
        if not imports[name]:
            lines.append("- Sem imports PE regulares detectados.")
        lines.append("")

    args.output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Escrito: {args.output.resolve()} ({len(payloads)} PE; {sum(map(len, imports.values()))} arestas de import)")


if __name__ == "__main__":
    main()
