function Enable-WifiADB {
    Check-Adb
    Write-Host "`n📶 Enabling ADB over Wi-Fi..." -ForegroundColor Cyan

    $ip = (& ".\adb.exe" shell ip route | Select-String -Pattern "src ([0-9.]+)").Matches.Groups[1].Value
    if (-not $ip) {
        Write-Host "[!] Could not detect device IP address." -ForegroundColor Red
        return
    }

    & ".\adb.exe" tcpip 5555
    & ".\adb.exe" connect $ip
    Write-Host "[✓] Connected to device at $ip:5555" -ForegroundColor Green
    Read-Host "Press Enter to return..."
}