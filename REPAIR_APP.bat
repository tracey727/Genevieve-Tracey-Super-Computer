@echo off
setlocal
cd /d "%~dp0"
title Repair GENEVIEVE Super Response
if exist .venv rmdir /s /q .venv
if exist __pycache__ rmdir /s /q __pycache__
echo Old local app environment removed.
echo The setup will now rebuild it.
call START_GENEVIEVE.bat
