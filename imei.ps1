function Spoof-IMEI {
    Check-Adb
    Write-Host "`n🧾 Attempting IMEI Spoof..." -ForegroundColor Cyan
    $chipset = & ".\adb.exe" shell getprop ro.board.platform

    if ($chipset -match "mt") {
        Write-Host "[*] Detected MediaTek device." -ForegroundColor Yellow
        Write-Host "[!] Spoofing IMEI requires root and MTK Engineering Mode."
    } elseif ($chipset -match "qcom") {
        Write-Host "[*] Detected Qualcomm device." -ForegroundColor Yellow
        Write-Host "[!] Qualcomm spoofing may require QPST or rooted EFS edit."
    } else {
        Write-Host "[!] Unknown chipset or unsupported for spoofing." -ForegroundColor Red
    }

    Read-Host "Press Enter to return..."
}