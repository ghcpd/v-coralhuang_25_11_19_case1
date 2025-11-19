@echo off
setlocal enabledelayedexpansion
REM Product Browser - Automated Test Suite for Windows
echo ================================================
echo Product Browser - Automated Test Suite
echo ================================================
echo.

set TESTS_PASSED=0
set TESTS_FAILED=0
set SERVER_PID=

REM Step 1: Verify dependencies
echo Step 1: Verifying dependencies...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Python 3 is installed
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] Python 3 is not installed
    set /a TESTS_FAILED+=1
    exit /b 1
)

REM Step 2: Check if index.html exists
echo.
echo Step 2: Checking project files...
if exist "index.html" (
    echo [PASS] index.html exists
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] index.html not found
    set /a TESTS_FAILED+=1
    exit /b 1
)

REM Step 3: Start the server in background
echo.
echo Step 3: Starting test server...
start /B python -m http.server 3000 > nul 2>&1
set SERVER_STARTED=1
echo Server started in background

REM Wait for server to be ready
echo Waiting for server to be ready...
set /a MAX_ATTEMPTS=30
set /a ATTEMPT=0
set SERVER_READY=0

:wait_loop
if %ATTEMPT% geq %MAX_ATTEMPTS% goto check_ready
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:3000' -TimeoutSec 1 -UseBasicParsing; exit 0 } catch { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
    set SERVER_READY=1
    goto check_ready
)
timeout /t 1 /nobreak >nul
set /a ATTEMPT+=1
echo|set /p=.
goto wait_loop

:check_ready
echo.
if %SERVER_READY% equ 1 (
    echo [PASS] Server is responding on port 3000
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] Server failed to start within 30 seconds
    set /a TESTS_FAILED+=1
    goto cleanup
)

REM Step 4: Test HTTP 200 response
echo.
echo Step 4: Testing HTTP responses...
powershell -Command "$response = Invoke-WebRequest -Uri 'http://localhost:3000' -UseBasicParsing; exit $response.StatusCode" >nul 2>&1
if %errorlevel% equ 200 (
    echo [PASS] GET / returns HTTP 200
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] GET / returned HTTP %errorlevel% (expected 200^)
    set /a TESTS_FAILED+=1
)

REM Step 5: Verify HTML content
echo.
echo Step 5: Verifying HTML content...

REM Create temporary PowerShell script for content checks
echo $response = Invoke-WebRequest -Uri 'http://localhost:3000' -UseBasicParsing; > temp_check.ps1
echo $content = $response.Content; >> temp_check.ps1
echo $checks = @('Product Browser', 'id="search"', 'id="category"', 'id="sort"', 'id="products"', 'id="loading"', 'id="empty-state"', 'productsData', 'tailwindcss'); >> temp_check.ps1
echo $failed = 0; >> temp_check.ps1
echo foreach ($check in $checks) { >> temp_check.ps1
echo     if ($content -match [regex]::Escape($check)) { >> temp_check.ps1
echo         Write-Host "[PASS] $check is present" >> temp_check.ps1
echo     } else { >> temp_check.ps1
echo         Write-Host "[FAIL] $check not found" >> temp_check.ps1
echo         $failed++ >> temp_check.ps1
echo     } >> temp_check.ps1
echo } >> temp_check.ps1
echo exit $failed >> temp_check.ps1

powershell -ExecutionPolicy Bypass -File temp_check.ps1
set CHECK_RESULT=%errorlevel%
del temp_check.ps1

if %CHECK_RESULT% equ 0 (
    set /a TESTS_PASSED+=9
) else (
    set /a TESTS_FAILED+=%CHECK_RESULT%
)

REM Cleanup
:cleanup
echo.
echo Stopping test server...
taskkill /F /IM python.exe /FI "WINDOWTITLE eq http.server" >nul 2>&1

REM Step 6: Final results
echo.
echo ================================================
echo Test Results Summary
echo ================================================
echo Passed: %TESTS_PASSED%
echo Failed: %TESTS_FAILED%
echo.

if %TESTS_FAILED% equ 0 (
    echo All tests passed!
    exit /b 0
) else (
    echo Some tests failed.
    exit /b 1
)
