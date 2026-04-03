@echo off
rem Run OpenClaw when "openclaw" is not on PATH (npm global bin = %AppData%\npm)
set "OC=%APPDATA%\npm\openclaw.cmd"
if not exist "%OC%" (
  echo Not found: %OC%
  echo Run: npm install -g openclaw@latest
  exit /b 1
)
"%OC%" %*
