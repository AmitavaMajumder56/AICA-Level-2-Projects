@echo off
title Stock and Crypto Trend Predictor
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
    echo Dependencies are not installed yet. Running install_dependencies.bat first ...
    call "%~dp0install_dependencies.bat"
    exit /b
)
echo Starting the dashboard - your browser will open at http://localhost:8501
echo Close this window to stop the app.
".venv\Scripts\python.exe" -m streamlit run app.py --server.port 8501
pause
