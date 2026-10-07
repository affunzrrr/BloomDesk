@echo off
cd /d "%~dp0"
if exist "..\Start-Demo-Database.ps1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "..\Start-Demo-Database.ps1"
  if errorlevel 1 (
    pause
    exit /b 1
  )
)
if exist "dist\BloomDesk\BloomDesk.exe" (
  start "BloomDesk" "dist\BloomDesk\BloomDesk.exe"
  exit /b 0
)
if exist "dist\bloomdesk-1.0.0.jar" (
  java -jar "dist\bloomdesk-1.0.0.jar"
) else (
  java -jar "target\bloomdesk-1.0.0.jar"
)
if errorlevel 1 pause
