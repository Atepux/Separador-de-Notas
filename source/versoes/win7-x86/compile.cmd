@echo off
setlocal
set "ROOT=%~dp0.."
set "NSIS=%ROOT%\toolchain\nsis-3.10\nsis-3.10\makensis.exe"
if not exist "%NSIS%" (
  echo NSIS portatil 3.10 nao encontrado em:
  echo %NSIS%
  echo Obtenha o zip oficial NSIS 3.10, confira SHA-256 fcdce3229717a2a148e7cda0ab5bdb667f39d8fb33ede1da8dabc336bd5ad110
  echo e extraia-o para toolchain\nsis-3.10 antes de compilar.
  exit /b 2
)
if not exist "%ROOT%\dist-final\SeparadorNF.exe" (
  echo Executavel final ausente. Execute gerar_exe.bat primeiro.
  exit /b 3
)
if not exist "%ROOT%\vendor\VC_redist.x86.14.28.29914.exe" (
  echo Redistribuivel Microsoft VC++ x86 offline ausente.
  exit /b 4
)
if not exist "%ROOT%\dist-installer" mkdir "%ROOT%\dist-installer"
pushd "%~dp0"
"%NSIS%" /V3 SeparadorNF.nsi
set "RESULT=%ERRORLEVEL%"
popd
if not "%RESULT%"=="0" exit /b %RESULT%
echo Instalador candidato compilado. Execute tests de install/uninstall em VM antes de distribuir.
exit /b 0
