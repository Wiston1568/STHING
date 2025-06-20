# start.ps1 — Downloads EXE if online, runs PS locally if not
Set-Location -Path $PSScriptRoot

$exeUrl = "https://github.com/wiston1568/STHING/raw/main/sththing.exe"
$exePath = "$env:TEMP\sththing.exe"

try {
    Write-Host "[*] Downloading latest STHING EXE..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath -ErrorAction Stop

    Write-Host "[*] Launching native EXE..." -ForegroundColor Green
    Start-Process $exePath -Wait
    return
}
catch {
    Write-Host "[!] Failed to download EXE — running local fallback." -ForegroundColor Yellow
}

# Ensure ADB is present
if (-not (Test-Path ".\adb.exe")) {
    Write-Error "[!] adb.exe missing!"
    exit 1
}

$adbOut = & .\adb.exe devices
if ($adbOut -notmatch "device$") {
    Write-Host "[!] No Android device detected. Enable USB debugging." -ForegroundColor Red
    exit 1
}

# Run the PowerShell tool
. .\run.ps1
