Set-Location -Path $PSScriptRoot
$exeUrl = "https://github.com/wiston1568/STTHING/raw/main/sththing.exe"
$exePath = "$env:TEMP\sththing.exe"

try {
    Write-Host "[*] Downloading EXE version..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath -UseBasicParsing -ErrorAction Stop
    Start-Process $exePath -Wait
    return
}
catch {
    Write-Host "[!] EXE download failed — running fallback." -ForegroundColor Yellow
}

if (-not (Test-Path ".\adb.exe")) {
    Write-Error "[X] adb.exe not found. Please run from correct folder."
    exit 1
}

$adbOut = & .\adb.exe devices
if ($adbOut -notmatch "device$") {
    Write-Host "[!] No Android device connected or authorized." -ForegroundColor Red
    exit 1
}

. .\run.ps1
