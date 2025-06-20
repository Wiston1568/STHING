# STHING Security Toolkit - Dev by Bug & wiston1568
# Ensure UTF-8 encoding with BOM for emoji support

Clear-Host

function Download-Adb {
    $url = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
    $zip = "platform-tools.zip"
    $folder = "platform-tools"

    Write-Host "`n[~] Downloading ADB platform tools..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

    Expand-Archive -Path $zip -DestinationPath $folder -Force
    Copy-Item "$folder\platform-tools\adb.exe" -Destination . -Force
    Copy-Item "$folder\platform-tools\AdbWinApi.dll" -Destination . -Force
    Copy-Item "$folder\platform-tools\AdbWinUsbApi.dll" -Destination . -Force

    Remove-Item $zip -Force
    Remove-Item $folder -Recurse -Force

    Write-Host "[✓] ADB tools downloaded and ready!" -ForegroundColor Green
}

function Check-Adb {
    if (-not (Test-Path ".\adb.exe")) {
        Write-Host "`n[!] adb.exe not found. Attempting download..." -ForegroundColor Yellow
        Download-Adb
    }
}

function Install-Magisk {
    Check-Adb
    if (-not (Test-Path ".\magisk.apk")) {
        Write-Host "`n[!] magisk.apk not found in folder." -ForegroundColor Red
        Write-Host "Please download and rename the APK to magisk.apk" -ForegroundColor Yellow
        Read-Host "Press Enter to continue..."
        return
    }

    Write-Host "`n⬇️  Installing Magisk Manager..." -ForegroundColor Cyan
    & ".\adb.exe" install -r "magisk.apk"
    Write-Host "✅ Magisk installation attempted." -ForegroundColor Green
    Read-Host "Press Enter to continue..."
}

function Scan-DeviceInfo {
    Check-Adb
    Write-Host "`n📡 Scanning device info..." -ForegroundColor Cyan
    function GetProp($prop) {
        return (& ".\adb.exe" shell getprop $prop).Trim()
    }

    $info = @{
        "Chipset"       = GetProp "ro.board.platform"
        "Serial"        = GetProp "ro.serialno"
        "Manufacturer"  = GetProp "ro.product.manufacturer"
        "Model"         = GetProp "ro.product.model"
        "Android"       = GetProp "ro.build.version.release"
    }

    foreach ($key in $info.Keys) {
        Write-Host "[+] ${key}:`t`t$($info[$key])"
    }
    Read-Host "Press Enter to continue..."
}

function Detect-MDM {
    Check-Adb
    Write-Host "`n🔍 Scanning for MDM..." -ForegroundColor Cyan

    $packages = & ".\adb.exe" shell pm list packages
    $owner = & ".\adb.exe" shell dpm get-device-owner

    if ($owner -match ":") {
        Write-Host "[!] Device Owner Active: $owner" -ForegroundColor Yellow
    } else {
        Write-Host "[✓] No active Device Owner." -ForegroundColor Green
    }

    $mdmMatches = @(
        "com.airwatch.androidagent",
        "com.mobileiron",
        "com.samsung.android.knox",
        "com.manageengine",
        "com.zebra.mdna"
    ) | Where-Object { $packages -match $_ }

    if ($mdmMatches.Count -gt 0) {
        Write-Host "`n[!] Potential MDM Packages Found:" -ForegroundColor Red
        $mdmMatches | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host "`n[✓] No known MDM packages detected." -ForegroundColor Green
    }

    Read-Host "Press Enter to continue..."
}

function Remove-MDM {
    Check-Adb
    Write-Host "`n🔥 Attempting MDM Removal..." -ForegroundColor Red
    $targets = @(
        "com.airwatch.androidagent",
        "com.mobileiron",
        "com.samsung.android.knox",
        "com.manageengine",
        "com.zebra.mdna"
    )

    foreach ($pkg in $targets) {
        Write-Host "[*] Trying to uninstall $pkg"
        & ".\adb.exe" shell pm uninstall --user 0 $pkg
        & ".\adb.exe" shell pm disable-user --user 0 $pkg
    }

    Write-Host "`n[✓] MDM removal attempted." -ForegroundColor Green
    Read-Host "Press Enter to continue..."
}

function Root-Detection {
    Check-Adb
    Write-Host "`n🧪 Detecting root access..." -ForegroundColor Cyan
    $su = & ".\adb.exe" shell which su

    if ($su) {
        Write-Host "[✓] su binary found: $su" -ForegroundColor Green
    } else {
        Write-Host "[!] su binary not found. Device likely unrooted." -ForegroundColor Yellow
    }

    Read-Host "Press Enter to continue..."
}

function Chipset-Info {
    Check-Adb
    Write-Host "`n🧠 Detecting chipset..." -ForegroundColor Cyan
    $chipset = & ".\adb.exe" shell getprop ro.board.platform
    Write-Host "[+] Chipset: $chipset"
    Read-Host "Press Enter to continue..."
}

function Full-AutoMode {
    Check-Adb
    Write-Host "`n🚀 Running Full Auto Mode..." -ForegroundColor Magenta
    Detect-MDM
    Remove-MDM
    Root-Detection
    Chipset-Info
    Scan-DeviceInfo
    Install-Magisk
}

# =================== Main Menu ===================
while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀"
    Write-Host "💀        STHING Security Tool              💀"
    Write-Host "💀     Dev by Bug & wiston1568             💀"
    Write-Host "💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀"
    Write-Host ""
    Write-Host "1. 🔍 Detect MDM"
    Write-Host "2. 🔥 Remove MDM (Root)"
    Write-Host "3. 🧾 Read IMEI (todo)"
    Write-Host "4. 🧪 Root Detection"
    Write-Host "5. 🚀 Full Auto Mode"
    Write-Host "6. ⬇️  Install Magisk Manager"
    Write-Host "7. 🧠 Chipset Info"
    Write-Host "8. 📡 Scan Device Info"
    Write-Host "0. ❌ Exit"
    Write-Host ""

    $choice = Read-Host "📲 Choose an option"

    switch ($choice) {
        "1" { Detect-MDM }
        "2" { Remove-MDM }
        "3" { Write-Host "IMEI spoofing is under construction. 😅"; Read-Host "Press Enter..." }
        "4" { Root-Detection }
        "5" { Full-AutoMode }
        "6" { Install-Magisk }
        "7" { Chipset-Info }
        "8" { Scan-DeviceInfo }
        "0" { break }
        default { Write-Host "[!] Invalid option, try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}


