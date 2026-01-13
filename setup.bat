@echo off
REM Product Browser - Setup Script for Windows
echo ================================================
echo Product Browser - Setup Script
echo ================================================
echo.

REM Check if Python 3 is installed
echo Checking for Python 3...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
    echo [OK] Found: %PYTHON_VERSION%
) else (
    echo [ERROR] Python 3 is not installed
    echo.
    echo Please install Python 3:
    echo   - Download from https://www.python.org/downloads/
    echo   - Make sure to check "Add Python to PATH" during installation
    exit /b 1
)

echo.
echo ================================================
echo Setup Complete!
echo ================================================
echo.
echo All dependencies are ready.
echo Run 'run.bat' to start the development server.
echo.
