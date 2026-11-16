param(
    [string]$ExePath = '',
    [int]$StartupWaitSeconds = 20
)

# Compatível com Windows PowerShell 2.0 (incluído no Windows 7).
$ErrorActionPreference = 'Continue'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$localData = $env:LOCALAPPDATA
if (!$localData) { $localData = Join-Path $env:USERPROFILE 'AppData\Local' }
$dataRoot = Join-Path $localData 'Separador de Notas'
if (!(Test-Path $dataRoot)) { New-Item -ItemType Directory -Force -Path $dataRoot | Out-Null }
$report = Join-Path $dataRoot ('diagnostico-win7-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.txt')
$lines = New-Object System.Collections.ArrayList
function Add-Line([string]$Text) { [void]$script:lines.Add($Text) }
function Add-Section([string]$Title) { Add-Line ''; Add-Line ('=== ' + $Title + ' ===') }
function Read-RegValue([string]$Key, [string]$Name) {
    $value = $null
    try { $value = (Get-ItemProperty -Path $Key -Name $Name -ErrorAction Stop).$Name } catch {}
    return $value
}

if (!$ExePath) {
    $adjacentExe = Join-Path $scriptRoot 'SeparadorNF.exe'
    if (Test-Path $adjacentExe) { $ExePath = $adjacentExe }
    else { $ExePath = Join-Path $scriptRoot 'dist-win7-test\SeparadorNF.exe' }
}
$ExePath = [IO.Path]::GetFullPath($ExePath)
Add-Line 'Diagnóstico Separador de Notas - Windows 7 x86'
Add-Line ('Data: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
Add-Line ('Executável: ' + $ExePath)

Add-Section 'Sistema operacional e arquitetura'
$osName = Read-RegValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' 'ProductName'
$csd = Read-RegValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' 'CSDVersion'
$arch = $env:PROCESSOR_ARCHITECTURE
$archWow = $env:PROCESSOR_ARCHITEW6432
$osArch = 'desconhecida'
try { $osArch = (Get-WmiObject Win32_OperatingSystem -ErrorAction Stop).OSArchitecture } catch {}
Add-Line ('ProductName: ' + $osName)
Add-Line ('Service Pack: ' + $csd)
Add-Line ('PROCESSOR_ARCHITECTURE: ' + $arch)
Add-Line ('PROCESSOR_ARCHITEW6432: ' + $archWow)
Add-Line ('WMI OSArchitecture: ' + $osArch)
if (($osName -match 'Windows 7') -and ($csd -match 'Service Pack 1') -and ($arch -eq 'x86') -and (!$archWow)) {
    Add-Line 'RESULTADO OS: PASS (Windows 7 SP1 x86)'
} else {
    Add-Line 'RESULTADO OS: FALHA/INCONCLUSIVO (requer Windows 7 SP1 de 32 bits)'
}

Add-Section 'UCRT / KB2999226'
$ucrtPath = Join-Path $env:windir 'System32\ucrtbase.dll'
$ucrtPresent = Test-Path $ucrtPath
Add-Line ('ucrtbase.dll presente: ' + $ucrtPresent + ' (' + $ucrtPath + ')')
if ($ucrtPresent) {
    try { Add-Line ('Versão ucrtbase.dll: ' + (Get-Item $ucrtPath).VersionInfo.FileVersion) } catch {}
}
$kb = 'não confirmado'
try {
    $qfe = Get-WmiObject Win32_QuickFixEngineering -ErrorAction Stop | Where-Object { $_.HotFixID -eq 'KB2999226' }
    if ($qfe) { $kb = 'instalada'; Add-Line ('KB2999226: instalada (' + $qfe.InstalledOn + ')') }
    else { $kb = 'não listada'; Add-Line 'KB2999226: não listada em Win32_QuickFixEngineering' }
} catch { Add-Line ('KB2999226: consulta WMI falhou: ' + $_.Exception.Message) }
$ucrtApis = @('api-ms-win-crt-conio-l1-1-0.dll','api-ms-win-crt-convert-l1-1-0.dll','api-ms-win-crt-environment-l1-1-0.dll','api-ms-win-crt-filesystem-l1-1-0.dll','api-ms-win-crt-heap-l1-1-0.dll','api-ms-win-crt-locale-l1-1-0.dll','api-ms-win-crt-math-l1-1-0.dll','api-ms-win-crt-process-l1-1-0.dll','api-ms-win-crt-runtime-l1-1-0.dll','api-ms-win-crt-stdio-l1-1-0.dll','api-ms-win-crt-string-l1-1-0.dll','api-ms-win-crt-time-l1-1-0.dll','api-ms-win-crt-utility-l1-1-0.dll')
$ucrtMissing = @()
foreach ($name in $ucrtApis) { if (!(Test-Path (Join-Path $env:windir ('System32\' + $name)))) { $ucrtMissing += $name } }
Add-Line ('API sets CRT encontrados: ' + ($ucrtApis.Count - $ucrtMissing.Count) + '/' + $ucrtApis.Count)
if ($ucrtMissing.Count) { Add-Line ('API sets CRT ausentes: ' + ($ucrtMissing -join ', ')) }
if ($ucrtPresent -and !$ucrtMissing.Count) { Add-Line ('RESULTADO UCRT: arquivos-base presentes; status KB2999226=' + $kb + '; validar self-check.') }
else { Add-Line 'RESULTADO UCRT: FALHA - componentes UCRT ausentes; não executar aplicativo.' }

Add-Section 'Microsoft Visual C++ Redistributable x86'
$vcKeys = @(
 'HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86',
 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\x86'
)
$vcFound = $false
$vcVersion = $null
foreach ($key in $vcKeys) {
    $installed = Read-RegValue $key 'Installed'
    $version = Read-RegValue $key 'Version'
    if ($installed -eq 1) { $vcFound = $true; $vcVersion = $version; Add-Line ('Redistributable encontrado: ' + $key + ' Installed=' + $installed + ' Version=' + $version) }
}
$vcDll = Join-Path $env:windir 'System32\msvcp140.dll'
$vcDllVersion = $null
if (Test-Path $vcDll) {
    try { $vcDllVersion = (Get-Item $vcDll).VersionInfo.FileVersion; Add-Line ('MSVCP140.dll FileVersion: ' + $vcDllVersion) } catch {}
}
$vcVersionOk = $false
try { if ([version]$vcDllVersion -ge [version]'14.28.29914.0') { $vcVersionOk = $true } } catch {}
if ($vcFound -and $vcVersionOk) { Add-Line 'RESULTADO VC++: PASS registral e MSVCP140 x86 >= 14.28.29914.0; confirmar self-check.' }
else { Add-Line 'RESULTADO VC++: FALHA - runtime x86 ausente ou versão abaixo de 14.28.29914.0.' }

Add-Section 'Arquivos da distribuição e arquitetura do executável'
if (Test-Path $ExePath) {
    $exeInfo = Get-Item $ExePath
    Add-Line ('Tamanho EXE: ' + $exeInfo.Length)
    Add-Line ('Versão EXE: ' + $exeInfo.VersionInfo.FileVersion)
    $cert = Get-AuthenticodeSignature -FilePath $ExePath
    Add-Line ('Assinatura EXE: ' + $cert.Status)
} else { Add-Line 'FALHA: executável não encontrado.' }
$runtime = Join-Path (Split-Path -Parent $ExePath) 'runtime\tesseract'
if (!(Test-Path $runtime)) { $runtime = Join-Path $scriptRoot 'runtime\tesseract' }
if (!(Test-Path $runtime)) { $runtime = $null }
foreach ($relative in @('tesseract.exe','tessdata\por.traineddata','tessdata\eng.traineddata')) {
    if ($runtime) {
        $candidate = Join-Path $runtime $relative
        Add-Line ($relative + ' externo: ' + (Test-Path $candidate))
    } else { Add-Line ($relative + ': presumido embutido no executável one-file; validar na inicialização/OCR') }
}
$dllNames = @('iconv.dll','libarchive-13.dll','libbz2-1.dll','libcurl-4.dll','libgcc_s_dw2-1.dll','libgcc_s_sjlj-1.dll','libgif-7.dll','libidn2-0.dll','libintl-8.dll','libjbig-2.dll','libjpeg-8.dll','liblept-5.dll','liblz4-1.dll','liblzma-5.dll','liblzo2-2.dll','libnghttp2-14.dll','libopenjp2.dll','libpng16-16.dll','libstdc++-6.dll','libtesseract-5.dll','libtiff-5.dll','libunistring-2.dll','libwebp-7.dll','libwinpthread-1.dll','libxml2-2.dll','libzstd-1.dll','zlib1.dll')
$missing = @()
if ($runtime) {
    foreach ($dll in $dllNames) { if (!(Test-Path (Join-Path $runtime $dll))) { $missing += $dll } }
    Add-Line ('DLLs nativas Tesseract conferidas na pasta externa: ' + ($dllNames.Count - $missing.Count) + '/' + $dllNames.Count)
    if ($missing.Count) { Add-Line ('DLLs ausentes: ' + ($missing -join ', ')) }
} else {
    Add-Line ('DLLs Tesseract esperadas embutidas no one-file: ' + $dllNames.Count + '; confirmação dinâmica pelo teste de inicialização/OCR.')
}

Add-Section 'Inicialização e captura de falha do loader'
if (Test-Path $ExePath) {
    $stdout = Join-Path $dataRoot 'diagnostico-exe-stdout.txt'
    $stderr = Join-Path $dataRoot 'diagnostico-exe-stderr.txt'
    Remove-Item $stdout,$stderr -Force -ErrorAction SilentlyContinue
    try {
        $proc = Start-Process -FilePath $ExePath -WorkingDirectory (Split-Path -Parent $ExePath) -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
        Start-Sleep -Seconds $StartupWaitSeconds
        $proc.Refresh()
        if ($proc.HasExited) {
            Add-Line ('PROCESSO ENCERROU antes de ' + $StartupWaitSeconds + 's; ExitCode=' + $proc.ExitCode)
            if ($proc.ExitCode -eq -1073741515) { Add-Line 'POSSÍVEL STATUS 0xC0000135: DLL não encontrada.' }
            if ($proc.ExitCode -eq -1073741701) { Add-Line 'POSSÍVEL STATUS 0xC000007B: arquitetura/formato incompatível.' }
            Add-Line ('Stdout: ' + $stdout)
            Add-Line ('Stderr: ' + $stderr)
        } else {
            Add-Line ('PROCESSO permaneceu ativo por ' + $StartupWaitSeconds + 's: provável inicialização bem-sucedida.')
            Stop-Process -Id $proc.Id -Force
            Add-Line 'Processo encerrado pelo diagnóstico após observar a inicialização.'
        }
    } catch { Add-Line ('ERRO ao iniciar processo: ' + $_.Exception.ToString()) }
} else { Add-Line 'Teste de inicialização ignorado: EXE ausente.' }

Add-Section 'Observações'
Add-Line 'O teste de inicialização não comprova OCR. Execute o roteiro VALIDACAO_WIN7.md com PDFs sintéticos e registre a rede desconectada.'
Add-Line 'Este script não instala/atualiza runtimes e não copia DLLs para o Windows.'
$lines | Out-File -FilePath $report -Encoding Unicode
Write-Host ('Relatório salvo em: ' + $report)
Write-Host ($lines -join [Environment]::NewLine)
