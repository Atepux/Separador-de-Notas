@echo off
setlocal
set "PYTHON=%~dp0.venv-win7-x86\Scripts\python.exe"
if not exist "%PYTHON%" goto ambiente_ausente

echo ============================================
echo  Build final x86 do SeparadorNF
echo ============================================
echo Usando o ambiente isolado do projeto.
echo.
"%PYTHON%" -m PyInstaller --clean --noconfirm --distpath "%~dp0dist-final" --workpath "%~dp0build-final" "%~dp0SeparadorNF.spec"
if errorlevel 1 goto erro

echo.
echo Executavel final criado em: dist-final\SeparadorNF.exe
pause
exit /b 0

:ambiente_ausente
echo O ambiente isolado .venv-win7-x86 nao foi encontrado.
echo Crie/preencha o ambiente antes de executar este script.
pause
exit /b 1

:erro
echo.
echo O build falhou. Consulte a saida do PyInstaller.
pause
exit /b 1
