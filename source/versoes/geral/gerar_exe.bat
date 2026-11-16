@echo off
echo ============================================
echo  Gerando SeparadorNF.exe
echo ============================================
echo.
echo [1/2] Instalando dependencias...
py -m pip install --upgrade pip
py -m pip install pymupdf zxing-cpp pillow pytesseract pyinstaller
if errorlevel 1 goto erro

echo.
echo [2/2] Criando o .exe (pode demorar alguns minutos)...
py -m PyInstaller --onefile --name SeparadorNF --collect-all pymupdf --collect-all zxingcpp --hidden-import pytesseract separar_nf.py
if errorlevel 1 goto erro

echo.
echo Pronto! O arquivo esta em: dist\SeparadorNF.exe
echo Copie o SeparadorNF.exe para uma pasta (ex.: C:\Notas) e de dois cliques.
echo As pastas entrada, processadas, revisar e originais serao criadas ao lado dele.
pause
exit /b 0

:erro
echo.
echo Ocorreu um erro. Verifique se o Python esta instalado (python.org) e tente de novo.
pause
exit /b 1
