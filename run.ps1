# run.ps1 — Local fallback logic with full interactive menu
function Scan-DeviceInfo {
    Write-Host "`n📡 Scanning device info..." -ForegroundColor Cyan

    $manufacturer = (& .\adb.exe shell getprop ro.product.manufacturer).Trim()
    $model = (& .\adb.exe shell getprop ro.product.model).Trim()
    $android = (& .\adb.exe shell getprop ro.build.version.release).Trim()
    $chipset = (& .\adb.exe shell getprop ro.board.platform).Trim()

    Write-Host "`n[+] Device: $manufacturer $model running Android $android"
    Write-Host "[+] Chipset: $chipset"
}

function Show-Menu {
    Clear-Host
    Write-Host "`n╔═════════════════════════════╗"
    Write-Host "║     STHING Security Tool     ║"
    Write-Host "║  Dev by Bug and wiston1568   ║"
    Write-Host "╚═════════════════════════════╝`n"
    Write-Host "1. 🔍 Advanced MDM Detection"
    Write-Host "2. 💀 Remove MDM (Root Only)"
    Write-Host "3. 📱 Spoof IMEI"
    Write-Host "4. ⚡ Root Device"
    Write-Host "5. 🧠 Full Auto Mode"
    Write-Host "6. 🔁 Restore Original IMEI"
    Write-Host "7. 🔬 Detect Chipset"
    Write-Host "8. 📡 Scan Device Info"
    Write-Host "9. 🔓 Smart Root Detection"
    Write-Host "0. ❌ Exit"
    Write-Host ""
}

while ($true) {
    Show-Menu
    $choice = Read-Host "💬 Enter option"

    switch ($choice) {
        '1' { Write-Host "[TODO] Advanced MDM Detection..." }
        '2' { Write-Host "[TODO] Remove MDM (requires root)" }
        '3' { Write-Host "[TODO] Spoof IMEI feature..." }
        '4' { Write-Host "[TODO] Rooting routine..." }
        '5' { Write-Host "[TODO] Full Auto Mode launching..." }
        '6' { Write-Host "[TODO] IMEI restore..." }
        '7' { Write-Host "[TODO] Chipset Detection placeholder" }
        '8' { Scan-DeviceInfo }
        '9' { Write-Host "[TODO] Smart root detection..." }
        '0' { Write-Host "Exiting..."; break }
        default { Write-Host "Invalid selection, try again." -ForegroundColor Red }
    }

    Write-Host "`nPress Enter to continue..."
    [void][System.Console]::ReadLine()
}
