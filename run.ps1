# STHING - PowerShell Android Security Toolkit
# Dev by Bug & wiston1568

Clear-Host
function Show-Menu {
    Clear-Host
    Write-Host "?????????????????????????????????????????????????????????????????????????????????????????????"
    Write-Host "???     STHING Security Tool     ???"
    Write-Host "???  Dev by Bug & wiston1568     ???"
    Write-Host "?????????????????????????????????????????????????????????????????????????????????????????????"
    Write-Host ""
    Write-Host "1. ???? Detect MDM"
    Write-Host "2. ???? Remove MDM (Root)"
    Write-Host "3. ???? Read IMEI"
    Write-Host "4. ???? Root Detection"
    Write-Host "5. ???? Full Auto Mode"
    Write-Host "6. ???? Install Magisk Manager"
    Write-Host "7. ???? Chipset Info"
    Write-Host "8. ???? Scan Device Info"
    Write-Host "0. ??? Exit"
    Write-Host ""
}

# Detect ADB
$adbPaths = @(".\adb.exe", ".\adb\adb.exe", "adb")
$adb = $null
foreach ($path in $adbPaths) {
    try {
        & $path version > $null 2>&1
        if ($LASTEXITCODE -eq 0 -or !$?) {
            $adb = $path
            break
        }
    } catch {
        continue
    }
}
if (-not $adb) {
    Write-Host "`n[!] adb.exe not found in current or adb folder." -ForegroundColor Red
    Write-Host "Please add adb.exe to this folder or add it to PATH."
    Read-Host "Press Enter to continue..."
    exit
}

function Scan-DeviceInfo {
    Write-Host "`n???? Scanning device info..."
    $props = @(
        @{Name="Chipset"; Prop="ro.board.platform"},
        @{Name="Serial"; Prop="ro.serialno"},
        @{Name="Manufacturer"; Prop="ro.product.manufacturer"},
        @{Name="Model"; Prop="ro.product.model"},
        @{Name="Android"; Prop="ro.build.version.release"}
    )
    foreach ($item in $props) {
        try {
            $value = (& $adb shell getprop $item.Prop).Trim()
            Write-Host "[+] $($item.Name): $value"
        } catch {
            Write-Host "[!] Failed to read $($item.Name)"
        }
    }
    Read-Host "`nPress Enter to continue..."
}

function Detect-MDM {
    Write-Host "`n???? Scanning for MDM..."
    try {
        $packages = & $adb shell pm list packages
        $mdm_keywords = "mdm","airwatch","suremdm","mobilock","maas360","knox","miradore","hexnode","scalefusion"
        $found = $false
        foreach ($pkg in $packages) {
            foreach ($keyword in $mdm_keywords) {
                if ($pkg -like "*$keyword*") {
                    Write-Host "[!] MDM Detected: $pkg" -ForegroundColor Yellow
                    $found = $true
                }
            }
        }
        $owner = & $adb shell dpm get-device-owner
        if ($owner -and $owner -notmatch "null") {
            Write-Host "`n[!] Device Owner Active: $owner" -ForegroundColor Red
        } elseif (-not $found) {
            Write-Host "[+] No MDM Detected." -ForegroundColor Green
        }
    } catch {
        Write-Host "[!] Error while scanning for MDM." -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue..."
}

function Read-IMEI {
    Write-Host "`n???? Reading IMEI..."
    try {
        $imei = & $adb shell service call iphonesubinfo 1 | Select-String -Pattern "'(.*?)'" | ForEach-Object { $_.Matches.Groups[1].Value } | ForEach-Object { $_.Trim() } | Out-String
        Write-Host "[+] IMEI: $imei"
    } catch {
        Write-Host "[!] Failed to read IMEI."
    }
    Read-Host "`nPress Enter to continue..."
}

function Root-Detection {
    Write-Host "`n???? Checking root status..."
    try {
        $su = & $adb shell which su
        if ($su -and $su.Trim() -ne "") {
            Write-Host "[+] Device appears to be rooted at: $su"
        } else {
            Write-Host "[!] Device not rooted."
        }
    } catch {
        Write-Host "[!] Could not verify root status."
    }
    Read-Host "`nPress Enter to continue..."
}

function Full-AutoMode {
    Write-Host "`n⚙️  Running Full Auto Mode..."
    Detect-MDM
    Root-Detection
    Read-IMEI
    Scan-DeviceInfo
    Read-Host "`nPress Enter to return to menu..."
}

function Install-Magisk {
    Write-Host "`n⬇️ Installing Magisk Manager APK..."
    $apkPath = ".\magisk.apk"
    if (Test-Path $apkPath) {
        & $adb install -r $apkPath
        Write-Host "[+] Magisk Manager installed."
    } else {
        Write-Host "[!] magisk.apk not found."
    }
    Read-Host "`nPress Enter to continue..."
}

function Show-ChipsetInfo {
    Write-Host "`n📡 Chipset Information:"
    try {
        $chip = (& $adb shell getprop ro.board.platform).Trim()
        Write-Host "[+] Chipset: $chip"
    } catch {
        Write-Host "[!] Could not read chipset."
    }
    Read-Host "`nPress Enter to continue..."
}

# MAIN LOOP
do {
    Show-Menu
    $choice = Read-Host "`n???? Choose an option"
    switch ($choice) {
        "1" { Detect-MDM }
        "2" { Write-Host "`n[!] MDM removal requires root. Not implemented in PowerShell." ; Read-Host "Press Enter..." }
        "3" { Read-IMEI }
        "4" { Root-Detection }
        "5" { Full-AutoMode }
        "6" { Install-Magisk }
        "7" { Show-ChipsetInfo }
        "8" { Scan-DeviceInfo }
        "0" { Write-Host "Exiting..." }
        default { Write-Host "Invalid selection." ; Start-Sleep -Seconds 1 }
    }
} while ($choice -ne "0")
