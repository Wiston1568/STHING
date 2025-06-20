function Stealth-Magisk {
    Check-Adb
    Write-Host "`n🕵️ Enabling stealth mode for Magisk..." -ForegroundColor Cyan

    & ".\adb.exe" shell pm hide com.topjohnwu.magisk
    & ".\adb.exe" shell pm disable-user com.topjohnwu.magisk
    Write-Host "[✓] Magisk hidden and disabled from launcher." -ForegroundColor Green

    Read-Host "Press Enter to return..."
}