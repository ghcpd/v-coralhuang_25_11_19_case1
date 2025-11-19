# test.ps1 - Automated tests comparing broken vs fixed SSR output

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Running SSR Tests" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Install Playwright browsers if not already installed
Write-Host "Installing Playwright browsers..." -ForegroundColor Yellow
npx playwright install chromium --with-deps

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Building both versions..." -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Build both versions
Write-Host "Building broken version..." -ForegroundColor Yellow
npm run build:broken

Write-Host ""
Write-Host "Building fixed version..." -ForegroundColor Yellow
npm run build:fixed

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Running Playwright tests..." -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Run Playwright tests
npx playwright test

$TEST_EXIT_CODE = $LASTEXITCODE

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Test Results" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

if ($TEST_EXIT_CODE -eq 0) {
    Write-Host "✅ All tests passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Summary:" -ForegroundColor Green
    Write-Host "  - Broken version correctly fails SSR style checks" -ForegroundColor White
    Write-Host "  - Fixed version passes all SSR style checks" -ForegroundColor White
    Write-Host "  - No hydration warnings in fixed version" -ForegroundColor White
    Write-Host "  - Styles persist with JavaScript disabled" -ForegroundColor White
} else {
    Write-Host "❌ Some tests failed" -ForegroundColor Red
    Write-Host "Check the output above for details" -ForegroundColor Yellow
}

exit $TEST_EXIT_CODE
