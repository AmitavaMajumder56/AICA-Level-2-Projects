@echo off
setlocal EnableExtensions
title Stock and Crypto Trend Predictor - Installer
cd /d "%~dp0"

echo ==================================================================
echo    Real-Time Stock and Crypto Trend Predictor - Installer
echo ==================================================================
echo.

rem ---------------------------------------------------------------
rem 1. Locate a suitable Python (3.12 / 3.11 / 3.10 preferred for TensorFlow)
rem ---------------------------------------------------------------
set "PY="
for %%V in (3.12 3.11 3.10 3.13 3) do (
    if not defined PY (
        py -%%V -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)" >nul 2>&1 && set "PY=py -%%V"
    )
)
if not defined PY (
    python -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)" >nul 2>&1 && set "PY=python"
)
if defined PY goto :found_python

echo [!] Python 3.9 or newer was not found on this computer.
where winget >nul 2>&1
if errorlevel 1 goto :no_winget
echo     Installing Python 3.12 with winget ...
winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements
echo.
echo     Python installed. CLOSE this window and run install_dependencies.bat again.
pause
exit /b 1

:no_winget
echo     Download Python 3.12 from https://www.python.org/downloads/
echo     IMPORTANT: tick "Add python.exe to PATH" during setup, then run this file again.
pause
exit /b 1

:found_python
echo [1/6] Using Python:
%PY% --version
echo.

rem ---------------------------------------------------------------
rem 2. Create an isolated virtual environment
rem ---------------------------------------------------------------
if exist ".venv\Scripts\python.exe" goto :venv_ready
echo [2/6] Creating virtual environment in .venv ...
%PY% -m venv .venv
if errorlevel 1 (
    echo [X] Could not create the virtual environment.
    pause
    exit /b 1
)
:venv_ready
set "VPY=%~dp0.venv\Scripts\python.exe"
echo [2/6] Virtual environment ready.
echo.

rem ---------------------------------------------------------------
rem 3. Upgrade pip tooling
rem ---------------------------------------------------------------
echo [3/6] Upgrading pip, setuptools and wheel ...
"%VPY%" -m pip install --upgrade pip setuptools wheel
echo.

rem ---------------------------------------------------------------
rem 4. Core dependencies
rem ---------------------------------------------------------------
echo [4/6] Installing / repairing core packages - streamlit, yfinance, pandas, scikit-learn, plotly, beautifulsoup4 ...
"%VPY%" -m pip install --upgrade -r requirements.txt
if errorlevel 1 (
    echo [X] Core package installation failed. Check your internet connection and try again.
    pause
    exit /b 1
)
echo.

rem ---------------------------------------------------------------
rem 5. Optional TensorFlow for the LSTM model
rem ---------------------------------------------------------------
echo [5/6] TensorFlow enables the LSTM deep-learning model - about 500 MB download.
choice /c YN /t 30 /d Y /m "Install TensorFlow now? Auto-selects Y in 30 seconds"
if errorlevel 2 goto :skip_tf
"%VPY%" -m pip install -r requirements-lstm.txt
if errorlevel 1 (
    echo [!] TensorFlow could not be installed for this Python version.
    echo     The app still works - it uses the scikit-learn neural network instead of LSTM.
)
goto :tf_done
:skip_tf
echo     Skipped. The app will use the scikit-learn models only.
:tf_done
echo.

rem ---------------------------------------------------------------
rem 6. Verify installation and pre-configure Streamlit
rem ---------------------------------------------------------------
echo [6/6] Verifying installation ...
set "CHECKLOG=%TEMP%\stock_predictor_check.log"
"%VPY%" -c "import pandas, numpy, sklearn, scipy, streamlit, yfinance, plotly, bs4, lxml, requests; print('    pandas', pandas.__version__, '| numpy', numpy.__version__, '| scikit-learn', sklearn.__version__, '| streamlit', streamlit.__version__)" > "%CHECKLOG%" 2>&1
set "CHECKERR=%errorlevel%"
type "%CHECKLOG%"
if "%CHECKERR%"=="0" goto :verify_ok

findstr /i /c:"Application Control" /c:"DLL load failed" "%CHECKLOG%" >nul
if errorlevel 1 goto :verify_other

echo.
echo ==================================================================
echo  [X] WINDOWS BLOCKED A PYTHON LIBRARY FILE - DLL
echo ==================================================================
echo  Windows Smart App Control or an Application Control policy is
echo  blocking compiled library files that pip downloaded.
echo.
echo  Step 1 - Trying a clean reinstall of long-established versions ...
"%VPY%" -m pip install --force-reinstall --no-cache-dir -r requirements.txt
"%VPY%" -c "import pandas, numpy, sklearn, scipy" >nul 2>&1
if not errorlevel 1 (
    echo  Clean reinstall fixed it.
    goto :verify_ok
)
echo.
echo  Still blocked. To fix it:
echo    1. Windows Security will open now.
echo    2. Click "Smart App Control settings" and set it to Off.
echo    3. Run run_app.bat again - no reinstall needed.
echo  Note: on some Windows 11 versions Smart App Control cannot be turned
echo  back on without resetting Windows.
echo  Work or college laptop? The policy is set by your IT team - ask them
echo  to allow Python packages, or use a personal computer.
echo.
start "" "windowsdefender://appbrowser"
pause
exit /b 1

:verify_other
echo [X] Verification failed - see the messages above.
echo     Try deleting the .venv folder and running this installer again.
pause
exit /b 1

:verify_ok
"%VPY%" tests\test_offline.py
if errorlevel 1 (
    echo [!] Self-test reported a problem - see the messages above.
) else (
    echo     Self-test passed.
)

rem Skip Streamlit's first-run e-mail prompt
if not exist "%USERPROFILE%\.streamlit" mkdir "%USERPROFILE%\.streamlit"
if not exist "%USERPROFILE%\.streamlit\credentials.toml" (
    > "%USERPROFILE%\.streamlit\credentials.toml" echo [general]
    >> "%USERPROFILE%\.streamlit\credentials.toml" echo email = ""
)

echo.
echo ==================================================================
echo    Installation complete.  Start the app any time with run_app.bat
echo ==================================================================
echo.
choice /c YN /m "Launch the dashboard now"
if errorlevel 2 goto :end
call "%~dp0run_app.bat"

:end
endlocal
exit /b 0
