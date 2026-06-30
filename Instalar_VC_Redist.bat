@echo off
title Instalador do Microsoft Visual C++ Redistributable

:: Verifica se está como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permissao de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo ==========================================
echo Instalando Microsoft Visual C++ Runtime...
echo ==========================================
echo.

cd /d "%TEMP%"

echo Baixando versao x64...
powershell -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile 'vc_redist.x64.exe'"

echo Baixando versao x86...
powershell -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x86.exe' -OutFile 'vc_redist.x86.exe'"

echo.
echo Instalando x64...
start /wait vc_redist.x64.exe /install /quiet /norestart

echo Instalando x86...
start /wait vc_redist.x86.exe /install /quiet /norestart

echo.
echo ==========================================
echo Instalacao concluida.
echo Reinicie o computador antes de abrir o programa.
echo ==========================================
pause