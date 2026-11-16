#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $MakensisPath
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$compiler = (Resolve-Path $MakensisPath).Path
$toolchainRoot = (Resolve-Path (Join-Path $projectRoot 'toolchain')).Path
if (-not $compiler.StartsWith($toolchainRoot, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Use um makensis.exe portátil dentro de '$toolchainRoot'; compilador externo/global não será usado."
}

$expectedExeHash = '85686AE30886559A316A6D8D446D24731DBB39152485E0E0BD15EDD1AF854577'
$expectedVcHash = '14563755AC24A874241935EF2C22C5FCE973ACB001F99E524145113B2DC638C1'
$appExe = Join-Path $projectRoot 'dist-final\SeparadorNF.exe'
$vcRedist = Join-Path $projectRoot 'vendor\VC_redist.x86.14.28.29914.exe'
$outputDir = Join-Path $projectRoot 'dist-installer'
$outputExe = Join-Path $outputDir 'SeparadorNF-Setup.exe'

if ((Get-FileHash $appExe -Algorithm SHA256).Hash -ne $expectedExeHash) {
    throw 'O executável de teste não tem o SHA-256 aprovado; interrompendo sem compilar.'
}
if ((Get-FileHash $vcRedist -Algorithm SHA256).Hash -ne $expectedVcHash) {
    throw 'O redistribuível VC++ não tem o SHA-256 aprovado; interrompendo sem compilar.'
}

$requiredFiles = @(
    'diagnostico_win7.ps1', 'MANUAL.txt', 'TERCEIROS_E_LICENCAS.md',
    'licenses\GNU-AGPL-3.0.txt', 'licenses\PyMuPDF-COPYING-AGPL.txt',
    'licenses\Pillow-LICENSE.txt', 'licenses\PyInstaller-COPYING.txt',
    'licenses\pytesseract-LICENSE.txt', 'licenses\Python-PSF-LICENSE.txt',
    'licenses\Tesseract-Apache-2.0.txt', 'licenses\tessdata_fast-LICENSE-Apache-2.0.txt',
    'licenses\zxing-cpp-LICENSE-Apache-2.0.txt', 'licenses\AUTHORS-Tesseract.txt',
    'licenses\THIRD_PARTY_COMPONENTS.md', 'licenses\NSIS-COPYING.txt'
)
foreach ($relativePath in $requiredFiles) {
    if (-not (Test-Path (Join-Path $projectRoot $relativePath) -PathType Leaf)) {
        throw "Arquivo requerido para o pacote não encontrado: $relativePath"
    }
}

$versionOutput = (& $compiler /VERSION 2>&1 | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $versionOutput -notmatch '3\.(10|11|12|13)') {
    throw "Não foi possível validar uma versão NSIS 3.10–3.13. Retorno: $versionOutput"
}
New-Item -ItemType Directory -Force $outputDir | Out-Null
if (Test-Path $outputExe) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    Copy-Item -LiteralPath $outputExe -Destination "$outputExe.before-$stamp.bak"
}

$beforeExeHash = (Get-FileHash $appExe -Algorithm SHA256).Hash
Push-Location (Join-Path $projectRoot 'installer')
try {
    & $compiler /V3 SeparadorNF.nsi
    $compileExit = $LASTEXITCODE
}
finally {
    Pop-Location
}
if ($compileExit -ne 0) { throw "makensis terminou com código $compileExit; examine o log de compilação." }
if (-not (Test-Path $outputExe -PathType Leaf)) { throw "Saída esperada não foi criada: $outputExe" }
if ((Get-FileHash $appExe -Algorithm SHA256).Hash -ne $beforeExeHash) {
    throw 'O executável de teste mudou durante a compilação; interrompendo.'
}

$installerHash = (Get-FileHash $outputExe -Algorithm SHA256).Hash
$installerBytes = (Get-Item $outputExe).Length
$buildInfo = @(
    "NSIS: $versionOutput",
    "Host: $([Environment]::OSVersion.VersionString)",
    "Built UTC: $([DateTime]::UtcNow.ToString('o'))",
    "Installer: $outputExe",
    "Bytes: $installerBytes",
    "SHA-256: $installerHash",
    "Application SHA-256: $beforeExeHash",
    'Release status: technical test candidate; Windows 7 not validated; redistribution licenses unresolved.'
)
$buildInfo | Set-Content -LiteralPath (Join-Path $outputDir 'SeparadorNF-Setup.build-info.txt') -Encoding UTF8
$buildInfo
