function Get-Prop($prop) {
    return (& ".\adb.exe" shell getprop $prop).Trim()
}

function Scan-DeviceInfo {
    Write-Host "`n📡 Scanning device info..." -ForegroundColor Cyan
    $info = @{
        Manufacturer = Get-Prop "ro.product.manufacturer"
        Model        = Get-Prop "ro.product.model"
        Android      = Get-Prop "ro.build.version.release"
        Chipset      = Get-Prop "ro.board.platform"
        Serial       = Get-Prop "ro.serialno"
    }
    $info.GetEnumerator() | ForEach-Object {
        Write-Host "[+] $($_.Key): $($_.Value)"
    }
}

function Read-IMEI {
    Write-Host "`n📱 Reading IMEI..."
    $out = & ".\adb.exe" shell service call iphonesubinfo 1
    if ($out -match "000000|not found|null") {
        Write-Host "⚠️ IMEI may be spoofed, unavailable, or blocked." -ForegroundColor Yellow
    }
    else {
        Write-Host "[IMEI Response]:`n$out"
    }
}

function Detect-Root {
    Write-Host "`n🔍 Checking for root..."
    $su = (& ".\adb.exe" shell which su).Trim()
    $magisk = Get-Prop "ro.magisk.version"
    if ($su -match "/") {
        Write-Host "[+] su binary found: $su" -ForegroundColor Green
        if ($magisk) { Write-Host "[+] Magisk version: $magisk" }
    }
    else {
        Write-Host "[-] No root access detected." -ForegroundColor Yellow
    }
}

function Detect-MDM {
    Write-Host "`n🔍 Scanning for MDM..."
    $knownMDMs = @(
        "com.airwatch.androidagent", "com.samsung.android.knox",
        "com.mobileiron", "com.microsoft.intune", "com.zebra.mdna"
    )
    $packages = & ".\adb.exe" shell pm list packages
    $detected = $false
    foreach ($mdm in $knownMDMs) {
        if ($packages -match $mdm) {
            Write-Host "[!] MDM Detected: $mdm" -ForegroundColor Red
            $detected = $true
        }
    }
    $owner = & ".\adb.exe" shell dpm get-device-owner
    if ($owner -notmatch "null") {
        Write-Host "[!] Device Owner Active: $owner" -ForegroundColor Yellow
        $detected = $true
    }
    if (-not $detected) {
        Write-Host "[✓] No MDMs detected." -ForegroundColor Green
    }
}

function Remove-MDM {
    Write-Host "`n💀 Removing known MDMs (requires root)..."
    $su = (& ".\adb.exe" shell which su).Trim()
    if ($su -notmatch "/") {
        Write-Host "[X] Root required to remove MDM apps." -ForegroundColor Red
        return
    }
    $mdms = @("com.airwatch.androidagent", "com.mobileiron", "com.microsoft.intune")
    foreach ($mdm in $mdms) {
        Write-Host "[*] Removing $mdm..."
        & ".\adb.exe" shell su -c "pm uninstall --user 0 $mdm"
    }
    Write-Host "[✓] MDM removal complete." -ForegroundColor Green
}

function Install-Magisk {
    Write-Host "`n📦 Installing Magisk Manager (APK)..."
    $apkUrl = "https://github.com/topjohnwu/Magisk/releases/latest/download/Magisk-v27.0.apk"
    $apk = "$env:TEMP\magisk.apk"
    Invoke-WebRequest -Uri $apkUrl -OutFile $apk
    & ".\adb.exe" push $apk /sdcard/Magisk.apk
    & ".\adb.exe" shell pm install -r /sdcard/Magisk.apk
    Write-Host "[✓] Magisk APK installed. Launch it from the phone." -ForegroundColor Cyan
}

function Full-Auto {
    Write-Host "`n🧠 Running Full Auto Mode..."
    Detect-MDM
    Read-IMEI
    Detect-Root
    Scan-DeviceInfo
}

function Show-Menu {
    Write-Host "`n╔═════════════════════════════╗"
    Write-Host "║     STHING Security Tool     ║"
    Write-Host "║  Dev by Bug & wiston1568     ║"
    Write-Host "╚═════════════════════════════╝`n"
    Write-Host "1. 🔍 Detect MDM"
    Write-Host "2. 💀 Remove MDM (Root)"
    Write-Host "3. 📱 Read IMEI"
    Write-Host "4. 🔓 Root Detection"
    Write-Host "5. 🧠 Full Auto Mode"
    Write-Host "6. 🧱 Install Magisk Manager"
    Write-Host "7. 🔬 Chipset Info"
    Write-Host "8. 📡 Scan Device Info"
    Write-Host "0. ❌ Exit`n"
}

# Main loop - safe and limited in depth
$loop = $true
while ($loop) {
    Show-Menu
    $choice = Read-Host "💬 Choose an option"
    switch ($choice) {
        '1' { Detect-MDM }
        '2' { Remove-MDM }
        '3' { Read-IMEI }
        '4' { Detect-Root }
        '5' { Full-Auto }
        '6' { Install-Magisk }
        '7' { Write-Host "`nChipset: $(Get-Prop 'ro.board.platform')" }
        '8' { Scan-DeviceInfo }
        '0' { $loop = $false }
        default { Write-Host "Invalid selection." -ForegroundColor Red }
    }
    if ($loop) {
        Write-Host "`nPress Enter to continue..."
        [void][System.Console]::ReadLine()
    }
}
