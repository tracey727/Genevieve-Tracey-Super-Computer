@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title GENEVIEVE Super Response Setup
color 0F

echo.
echo ==========================================================
echo        GENEVIEVE SUPER RESPONSE - WINDOWS STARTER
echo ==========================================================
echo.

set "PYTHON_CMD="
where py >nul 2>nul && set "PYTHON_CMD=py"
if not defined PYTHON_CMD (
  where python >nul 2>nul && set "PYTHON_CMD=python"
)

if not defined PYTHON_CMD (
  echo Python is not installed or Windows cannot find it.
  echo.
  where winget >nul 2>nul
  if errorlevel 1 goto NO_WINGET
  echo Installing official Python 3.12 through Windows Package Manager...
  winget install --id Python.Python.3.12 -e --accept-package-agreements --accept-source-agreements
  if errorlevel 1 goto INSTALL_FAILED
  set "PYTHON_CMD=py"
)

%PYTHON_CMD% -c "import sys; assert sys.version_info >= (3,10)" >nul 2>nul
if errorlevel 1 (
  echo Your Python version is too old. Installing Python 3.12...
  where winget >nul 2>nul || goto NO_WINGET
  winget install --id Python.Python.3.12 -e --accept-package-agreements --accept-source-agreements
  if errorlevel 1 goto INSTALL_FAILED
  set "PYTHON_CMD=py"
)

if not exist ".venv\Scripts\python.exe" (
  echo Creating the private app environment...
  %PYTHON_CMD% -m venv .venv
  if errorlevel 1 goto VENV_FAILED
)

echo Checking required components...
".venv\Scripts\python.exe" -m pip install --upgrade pip >nul
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto PACKAGE_FAILED

echo Starting GENEVIEVE Super Response...
start "" ".venv\Scripts\pythonw.exe" app.py
exit /b 0

:NO_WINGET
echo.
echo Automatic Python installation is unavailable on this Windows computer.
echo Opening the official Python download page.
start "" "https://www.python.org/downloads/windows/"
echo Install Python and tick: Add python.exe to PATH.
pause
exit /b 1

:INSTALL_FAILED
echo.
echo Windows could not install Python automatically.
start "" "https://www.python.org/downloads/windows/"
echo Install Python, tick Add python.exe to PATH, then double-click this file again.
pause
exit /b 1

:VENV_FAILED
echo.
echo Python was found, but its virtual environment could not be created.
echo Run REPAIR_APP.bat, then try again.
pause
exit /b 1

:PACKAGE_FAILED
echo.
echo Required packages could not be installed.
echo Check the internet connection, then run REPAIR_APP.bat.
pause
exit /b 1
