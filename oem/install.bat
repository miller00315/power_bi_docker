@echo off
REM Executado automaticamente ao final da instalacao do Windows

REM Permite abrir programas isolados via RemoteApp (so a janela do Power BI)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList" /v fDisabledAllowList /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fAllowUnlistedRemotePrograms /t REG_DWORD /d 1 /f

echo Baixando Power BI Desktop...
curl.exe -L -o "%TEMP%\PBIDesktopSetup_x64.exe" "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe"
echo Instalando Power BI Desktop...
"%TEMP%\PBIDesktopSetup_x64.exe" -quiet -norestart ACCEPT_EULA=1
del "%TEMP%\PBIDesktopSetup_x64.exe"
