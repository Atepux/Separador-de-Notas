Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"

!define APP_NAME "Separador de Notas"
!define APP_VERSION "1.0.0"
!define APP_REGKEY "Software\Separador de Notas"
!define VC_REGKEY "Software\Microsoft\VisualStudio\14.0\VC\Runtimes\x86"
!define VC_FILE "VC_redist.x86.14.28.29914.exe"
!define APP_EXE "SeparadorNF.exe"

Name "${APP_NAME} ${APP_VERSION} - Windows 7 x86"
OutFile "..\dist-installer\SeparadorNF-Setup.exe"
InstallDir "$PROGRAMFILES\Separador de Notas"
RequestExecutionLevel admin
ShowInstDetails show
ShowUninstDetails show
SetCompressor /SOLID lzma
SetCompressorDictSize 32
CRCCheck force
VIProductVersion "1.0.0.0"
VIAddVersionKey /LANG=1046 "ProductName" "Separador de Notas"
VIAddVersionKey /LANG=1046 "FileDescription" "Instalador offline para Windows 7 SP1 x86; sistema real não validado"
VIAddVersionKey /LANG=1046 "ProductVersion" "${APP_VERSION}"

Var LogHandle
Var LogPath
Var RuntimeOK
Var UcrtOK
Var OldExePresent

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "PortugueseBR"

Function Log
  Exch $0
  FileWrite $LogHandle "$0$\r$\n"
  Pop $0
FunctionEnd

Function InitLog
  CreateDirectory "$COMMONAPPDATA\Separador de Notas"
  StrCpy $LogPath "$COMMONAPPDATA\Separador de Notas\instalacao.log"
  FileOpen $LogHandle $LogPath a
  Push "Início da instalação $(^Name)"
  Call Log
FunctionEnd

Function CheckTargetOS
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "ProductName"
  ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CSDVersion"
  ReadEnvStr $2 "PROCESSOR_ARCHITECTURE"
  ReadEnvStr $3 "PROCESSOR_ARCHITEW6432"
  Push "Sistema: $0 / $1 / processo=$2 / arch64=$3"
  Call Log
  ${If} $0 != "Windows 7"
  ${AndIf} $0 != "Windows 7 Professional"
  ${AndIf} $0 != "Windows 7 Ultimate"
  ${AndIf} $0 != "Windows 7 Home Premium"
  ${AndIf} $0 != "Windows 7 Home Basic"
  ${AndIf} $0 != "Windows 7 Starter"
  ${AndIf} $0 != "Windows 7 Enterprise"
    Goto os_bad
  ${EndIf}
  ${If} $1 != "Service Pack 1"
  ${OrIf} $2 != "x86"
  ${OrIf} $3 != ""
    Goto os_bad
  ${EndIf}
  Return
os_bad:
  Push "BLOQUEIO: sistema fora do alvo Windows 7 SP1 x86."
  Call Log
  MessageBox MB_ICONSTOP|MB_OK "Este pacote requer Windows 7 SP1 de 32 bits. A instalação foi interrompida."
  Abort
FunctionEnd

Function CheckUCRT
  StrCpy $UcrtOK 1
  ${For} $R0 0 12
    StrCmp $R0 0 0 +2
    StrCpy $R1 "api-ms-win-crt-conio-l1-1-0.dll"
    StrCmp $R0 1 0 +2
    StrCpy $R1 "api-ms-win-crt-convert-l1-1-0.dll"
    StrCmp $R0 2 0 +2
    StrCpy $R1 "api-ms-win-crt-environment-l1-1-0.dll"
    StrCmp $R0 3 0 +2
    StrCpy $R1 "api-ms-win-crt-filesystem-l1-1-0.dll"
    StrCmp $R0 4 0 +2
    StrCpy $R1 "api-ms-win-crt-heap-l1-1-0.dll"
    StrCmp $R0 5 0 +2
    StrCpy $R1 "api-ms-win-crt-locale-l1-1-0.dll"
    StrCmp $R0 6 0 +2
    StrCpy $R1 "api-ms-win-crt-math-l1-1-0.dll"
    StrCmp $R0 7 0 +2
    StrCpy $R1 "api-ms-win-crt-process-l1-1-0.dll"
    StrCmp $R0 8 0 +2
    StrCpy $R1 "api-ms-win-crt-runtime-l1-1-0.dll"
    StrCmp $R0 9 0 +2
    StrCpy $R1 "api-ms-win-crt-stdio-l1-1-0.dll"
    StrCmp $R0 10 0 +2
    StrCpy $R1 "api-ms-win-crt-string-l1-1-0.dll"
    StrCmp $R0 11 0 +2
    StrCpy $R1 "api-ms-win-crt-time-l1-1-0.dll"
    StrCmp $R0 12 0 +2
    StrCpy $R1 "api-ms-win-crt-utility-l1-1-0.dll"
    IfFileExists "$SYSDIR\$R1" ucrt_component_present
      StrCpy $UcrtOK 0
      Push "UCRT/API-set ausente: $R1"
      Call Log
ucrt_component_present:
  ${Next}
  IfFileExists "$SYSDIR\ucrtbase.dll" ucrt_base_present
    StrCpy $UcrtOK 0
    Push "UCRT ausente: ucrtbase.dll"
    Call Log
ucrt_base_present:
  Push "UCRT API sets e ucrtbase.dll presentes=$UcrtOK; verificação funcional será repetida pelo self-check."
  Call Log
FunctionEnd

Function CheckRuntime
  StrCpy $RuntimeOK 0
  StrCpy $1 "0"
  StrCpy $2 "0"
  SetRegView 32
  ReadRegDWORD $0 HKLM "${VC_REGKEY}" "Installed"
  IfFileExists "$SYSDIR\msvcp140.dll" 0 vc_checked
  GetDLLVersion "$SYSDIR\msvcp140.dll" $1 $2
  ${If} $0 == 1
  ${AndIf} $1 >= 0x000E001C
  ${AndIf} $2 >= 0x74DA0000
    StrCpy $RuntimeOK 1
  ${EndIf}
vc_checked:
  ${If} $RuntimeOK == 0
    Push "VC++ x86 ausente/incompatível: requer MSVCP140 >= 14.28.29914 e registro Installed=1."
    Call Log
  ${EndIf}
  Push "VC++ x86 registry Installed=$0; MSVCP140 version DWORDs=$1/$2; valid=$RuntimeOK"
  Call Log
FunctionEnd

Function StageResume
  CreateDirectory "$COMMONAPPDATA\Separador de Notas\SetupResume"
  CopyFiles /SILENT "$EXEPATH" "$COMMONAPPDATA\Separador de Notas\SetupResume\setup.exe"
  IfFileExists "$COMMONAPPDATA\Separador de Notas\SetupResume\setup.exe" 0 resume_fail
  SetRegView 32
  WriteRegDWORD HKLM "${APP_REGKEY}" "InstallPendingReboot" 1
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\RunOnce" "SeparadorNotasSetupResume" "$\"$COMMONAPPDATA\Separador de Notas\SetupResume\setup.exe$\" /RESUME"
  Push "Setup salvo e retomada configurada em RunOnce."
  Call Log
  Return
resume_fail:
  MessageBox MB_ICONSTOP|MB_OK "O runtime solicitou reinicialização e não foi possível salvar a retomada. Reinicie e execute este instalador novamente."
  Abort
FunctionEnd

Function .onInit
  Call InitLog
  Call CheckTargetOS
  Call CheckUCRT
  Call CheckRuntime
  ${If} $UcrtOK == 0
  ${OrIf} $RuntimeOK == 0
    InitPluginsDir
    SetOutPath "$PLUGINSDIR"
    File "..\vendor\${VC_FILE}"
    ExecWait "$\"$PLUGINSDIR\${VC_FILE}$\" /install /quiet /norestart" $0
    Push "VC_redist executado; código=$0; rechecando componentes."
    Call Log
    ${If} $0 == 3010
      Call StageResume
      MessageBox MB_ICONEXCLAMATION|MB_YESNO "O redistribuível solicitou reinicialização. O instalador será retomado após reiniciar. Reiniciar agora?" IDYES reboot_now IDNO reboot_later
reboot_now:
      Reboot
reboot_later:
      MessageBox MB_ICONINFORMATION|MB_OK "Reinicie o computador para retomar automaticamente a instalação."
      Abort
    ${EndIf}
    Call CheckUCRT
    Call CheckRuntime
    ${If} $UcrtOK == 0
    ${OrIf} $RuntimeOK == 0
      Push "ERRO: runtime não foi confirmado após o instalador."
      Call Log
      MessageBox MB_ICONSTOP|MB_OK "Não foi possível confirmar UCRT e/ou Visual C++ x86. O aplicativo não será instalado. Consulte $LogPath."
      Abort
    ${EndIf}
  ${EndIf}
  InitPluginsDir
  SetOutPath "$PLUGINSDIR"
  File "..\dist-final\${APP_EXE}"
  ExecWait "$\"$PLUGINSDIR\${APP_EXE}$\" --self-check" $0
  Push "Self-check antes da instalação retornou $0."
  Call Log
  ${If} $0 != 0
    MessageBox MB_ICONSTOP|MB_OK "O executável falhou no self-check. A instalação foi interrompida. Consulte $LogPath."
    Abort
  ${EndIf}
FunctionEnd

Section "Aplicativo" SEC_APP
  SetOutPath "$INSTDIR"
  IfFileExists "$INSTDIR\${APP_EXE}" 0 new_install
    Delete "$INSTDIR\${APP_EXE}.previous"
    Rename "$INSTDIR\${APP_EXE}" "$INSTDIR\${APP_EXE}.previous"
    IfErrors install_failed
new_install:
  File /oname=${APP_EXE}.new "..\dist-final\${APP_EXE}"
  Rename "$INSTDIR\${APP_EXE}.new" "$INSTDIR\${APP_EXE}"
  IfErrors restore_previous
  ExecWait "$\"$INSTDIR\${APP_EXE}$\" --self-check" $0
  ${If} $0 != 0
    Goto restore_previous
  ${EndIf}
  Delete "$INSTDIR\${APP_EXE}.previous"
  Delete "$COMMONAPPDATA\Separador de Notas\SetupResume\setup.exe"
  RMDir "$COMMONAPPDATA\Separador de Notas\SetupResume"
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\RunOnce" "SeparadorNotasSetupResume"
  WriteUninstaller "$INSTDIR\uninstall.exe"
  CreateDirectory "$SMPROGRAMS\Separador de Notas"
  CreateShortcut "$SMPROGRAMS\Separador de Notas\Separador de Notas.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0
  WriteRegStr HKLM "${APP_REGKEY}" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "${APP_REGKEY}" "Version" "${APP_VERSION}"
  WriteRegDWORD HKLM "${APP_REGKEY}" "InstallPendingReboot" 0
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Separador de Notas" "DisplayName" "${APP_NAME} ${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Separador de Notas" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  SetOutPath "$INSTDIR"
  File "..\diagnostico_win7.ps1"
  File "..\MANUAL.txt"
  File "..\TERCEIROS_E_LICENCAS.md"
  SetOutPath "$INSTDIR\licenses"
  File "..\licenses\GNU-AGPL-3.0.txt"
  File "..\licenses\PyMuPDF-COPYING-AGPL.txt"
  File "..\licenses\Pillow-LICENSE.txt"
  File "..\licenses\PyInstaller-COPYING.txt"
  File "..\licenses\pytesseract-LICENSE.txt"
  File "..\licenses\Python-PSF-LICENSE.txt"
  File "..\licenses\Tesseract-Apache-2.0.txt"
  File "..\licenses\tessdata_fast-LICENSE-Apache-2.0.txt"
  File "..\licenses\zxing-cpp-LICENSE-Apache-2.0.txt"
  File "..\licenses\AUTHORS-Tesseract.txt"
  File "..\licenses\THIRD_PARTY_COMPONENTS.md"
  File "..\licenses\NSIS-COPYING.txt"
  Push "Aplicativo instalado; arquivos do usuário em LocalAppData permanecem fora do diretório do programa."
  Call Log
  Goto install_done
restore_previous:
  Delete "$INSTDIR\${APP_EXE}"
  IfFileExists "$INSTDIR\${APP_EXE}.previous" 0 install_failed
  Rename "$INSTDIR\${APP_EXE}.previous" "$INSTDIR\${APP_EXE}"
install_failed:
  Push "Falha na substituição/validação do executável; versão anterior restaurada quando existente."
  Call Log
  MessageBox MB_ICONSTOP|MB_OK "A instalação falhou ao validar o aplicativo. Consulte o log: $LogPath"
  Abort
install_done:
SectionEnd

Function un.onInit
  StrCpy $LogPath "$COMMONAPPDATA\Separador de Notas\instalacao.log"
  FileOpen $LogHandle $LogPath a
FunctionEnd

Function un.Log
  Exch $0
  FileWrite $LogHandle "$0$\r$\n"
  Pop $0
FunctionEnd

Section "Uninstall"
  Delete "$INSTDIR\${APP_EXE}"
  Delete "$INSTDIR\uninstall.exe"
  Delete "$INSTDIR\diagnostico_win7.ps1"
  Delete "$INSTDIR\MANUAL.txt"
  Delete "$INSTDIR\TERCEIROS_E_LICENCAS.md"
  Delete "$INSTDIR\licenses\GNU-AGPL-3.0.txt"
  Delete "$INSTDIR\licenses\PyMuPDF-COPYING-AGPL.txt"
  Delete "$INSTDIR\licenses\Pillow-LICENSE.txt"
  Delete "$INSTDIR\licenses\PyInstaller-COPYING.txt"
  Delete "$INSTDIR\licenses\pytesseract-LICENSE.txt"
  Delete "$INSTDIR\licenses\Python-PSF-LICENSE.txt"
  Delete "$INSTDIR\licenses\Tesseract-Apache-2.0.txt"
  Delete "$INSTDIR\licenses\tessdata_fast-LICENSE-Apache-2.0.txt"
  Delete "$INSTDIR\licenses\zxing-cpp-LICENSE-Apache-2.0.txt"
  Delete "$INSTDIR\licenses\AUTHORS-Tesseract.txt"
  Delete "$INSTDIR\licenses\THIRD_PARTY_COMPONENTS.md"
  Delete "$INSTDIR\licenses\NSIS-COPYING.txt"
  RMDir "$INSTDIR\licenses"
  RMDir "$INSTDIR"
  Delete "$SMPROGRAMS\Separador de Notas\Separador de Notas.lnk"
  RMDir "$SMPROGRAMS\Separador de Notas"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Separador de Notas"
  DeleteRegKey HKLM "${APP_REGKEY}"
  Push "Desinstalado; dados/PDFs em LocalAppData preservados."
  Call un.Log
SectionEnd
