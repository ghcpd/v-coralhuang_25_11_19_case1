# capture-screenshots.ps1 - Capture screenshots of broken and fixed versions

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Capturing Screenshots" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Starting servers..." -ForegroundColor Yellow

# Start broken version server in background
$brokenJob = Start-Job -ScriptBlock {
    Set-Location "c:\Bug_Bash\25_11_19\v-coralhuang_25_11_19_case1"
    & "C:\Program Files\nodejs\npm.cmd" run start:broken 2>&1 | Out-Null
}

Start-Sleep -Seconds 3

# Start fixed version server in background
$fixedJob = Start-Job -ScriptBlock {
    Set-Location "c:\Bug_Bash\25_11_19\v-coralhuang_25_11_19_case1"
    & "C:\Program Files\nodejs\npm.cmd" run start:fixed 2>&1 | Out-Null
}

Write-Host "Waiting for servers to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 8

Write-Host ""
Write-Host "Capturing screenshots..." -ForegroundColor Green

# Run the screenshot capture script
& "C:\Program Files\nodejs\npx.cmd" ts-node scripts/capture-screenshots.ts

Write-Host ""
Write-Host "Stopping servers..." -ForegroundColor Yellow

# Stop the servers
Stop-Job -Job $brokenJob
Remove-Job -Job $brokenJob
Stop-Job -Job $fixedJob
Remove-Job -Job $fixedJob

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "Screenshot capture complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Screenshots saved to:" -ForegroundColor White
Write-Host "  - screenshots/broken.png" -ForegroundColor White
Write-Host "  - screenshots/fixed.png" -ForegroundColor White
