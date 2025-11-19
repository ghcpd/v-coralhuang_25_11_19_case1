# run.ps1 - Launch dev or production server to observe both broken and fixed version behavior

param(
    [string]$Mode = "dev"
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Running Next.js servers in $Mode mode" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if ($Mode -eq "dev") {
    Write-Host "Starting BROKEN version on http://localhost:3000" -ForegroundColor Yellow
    Write-Host "Starting FIXED version on http://localhost:3001" -ForegroundColor Green
    Write-Host ""
    Write-Host "Press Ctrl+C to stop both servers" -ForegroundColor White
    Write-Host ""
    
    # Start both dev servers in separate processes
    $brokenJob = Start-Process -FilePath "npm" -ArgumentList "run", "dev:broken" -NoNewWindow -PassThru
    Start-Sleep -Seconds 2
    $fixedJob = Start-Process -FilePath "npm" -ArgumentList "run", "dev:fixed" -NoNewWindow -PassThru
    
    Write-Host "Both servers started. Press any key to stop them..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    # Stop both processes
    Stop-Process -Id $brokenJob.Id -Force -ErrorAction SilentlyContinue
    Stop-Process -Id $fixedJob.Id -Force -ErrorAction SilentlyContinue
    
} elseif ($Mode -eq "prod") {
    Write-Host "Building both versions..." -ForegroundColor Yellow
    npm run build:broken
    npm run build:fixed
    
    Write-Host ""
    Write-Host "Starting BROKEN version on http://localhost:3000" -ForegroundColor Yellow
    Write-Host "Starting FIXED version on http://localhost:3001" -ForegroundColor Green
    Write-Host ""
    Write-Host "Press Ctrl+C to stop both servers" -ForegroundColor White
    Write-Host ""
    
    # Start both production servers
    $brokenJob = Start-Process -FilePath "npm" -ArgumentList "run", "start:broken" -NoNewWindow -PassThru
    Start-Sleep -Seconds 2
    $fixedJob = Start-Process -FilePath "npm" -ArgumentList "run", "start:fixed" -NoNewWindow -PassThru
    
    Write-Host "Both servers started. Press any key to stop them..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    # Stop both processes
    Stop-Process -Id $brokenJob.Id -Force -ErrorAction SilentlyContinue
    Stop-Process -Id $fixedJob.Id -Force -ErrorAction SilentlyContinue
    
} else {
    Write-Host "Usage: .\run.ps1 [dev|prod]" -ForegroundColor Red
    Write-Host "  dev  - Start development servers (default)" -ForegroundColor White
    Write-Host "  prod - Build and start production servers" -ForegroundColor White
    exit 1
}
