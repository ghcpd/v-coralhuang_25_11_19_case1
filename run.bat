@echo off
REM Product Browser - Run Script for Windows
echo ================================================
echo Product Browser - Starting Development Server
echo ================================================
echo.

REM Check if index.html exists
if not exist "index.html" (
    echo [ERROR] index.html not found in current directory
    exit /b 1
)

echo Starting server on http://localhost:3000
echo Press Ctrl+C to stop the server
echo.

REM Start Python HTTP server on port 3000
python -m http.server 3000
