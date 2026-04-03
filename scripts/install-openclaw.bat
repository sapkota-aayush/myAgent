@echo off
setlocal
rem npm puts global CLIs in %AppData%\npm — often missing from PATH for cmd
set "PATH=%APPDATA%\npm;%PATH%"

echo Using cmd.exe npm (avoids PowerShell npm.ps1 policy issues).
echo.

where npm >nul 2>&1
if errorlevel 1 (
  echo ERROR: npm not found. Install Node from https://nodejs.org and reopen this window.
  pause
  exit /b 1
)

echo --- npm uninstall -g openclaw (ok if nothing installed) ---
call npm uninstall -g openclaw

echo.
echo --- npm install -g openclaw@latest ---
call npm install -g openclaw@latest
if errorlevel 1 (
  echo.
  echo If you see EBUSY: close all terminals, stop OpenClaw, end extra Node in Task Manager, then run this again.
  pause
  exit /b 1
)

echo.
echo --- openclaw --version ---
openclaw --version
if errorlevel 1 (
  echo Add npm global folder to PATH, or run: "%AppData%\npm\openclaw.cmd" --version
  pause
  exit /b 1
)

echo.
echo Next, in this same window run:
echo   openclaw onboard --install-daemon
echo.
echo If openclaw is still not found in NEW terminals, add to your user PATH:
echo   %%AppData%%\npm
echo (Win+R: sysdm.cpl ^> Advanced ^> Environment Variables ^> Path ^> Edit)
echo Or always run: "%%AppData%%\npm\openclaw.cmd" onboard --install-daemon
echo.
pause
