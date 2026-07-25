@echo off
cd /d "%~dp0"
if not exist ".venv\Scripts\pythonw.exe" (
  call START_GENEVIEVE.bat
  exit /b
)
start "" ".venv\Scripts\pythonw.exe" app.py
