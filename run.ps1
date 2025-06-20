# Downloads and executes the Windows build of STHING
$exeUrl = "https://github.com/wiston1568/STHING/raw/main/sththing.exe"
$exePath = "$env:TEMP\sththing.exe"

Write-Host "Downloading STHING..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

Write-Host "Launching STHING..." -ForegroundColor Green
Start-Process $exePath -Wait
