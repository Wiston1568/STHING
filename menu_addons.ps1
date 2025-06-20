# ===============================
# STHING Add-ons Menu
# Dev by Bug & wiston1568
# ===============================

function Open-AddonMenu {
    while ($true) {
        Clear-Host
        Write-Host ""
        Write-Host "🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰"
        Write-Host "🧰     STHING Add-ons Menu"
        Write-Host "🧰     Dev by Bug & wiston1568"
        Write-Host "🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰🧰"
        Write-Host ""
        Write-Host "1. 🧾 IMEI Tools"
        Write-Host "2. 📶 Enable ADB Over Wi-Fi"
        Write-Host "3. 🕵️‍♂️ Activate Stealth Mode"
        Write-Host "0. 🔙 Back to Main Menu"
        Write-Host ""

        $addonChoice = Read-Host "Select an option"

        switch ($addonChoice) {
            "1" {
                if (Test-Path ".\imei.ps1") {
                    . .\imei.ps1
                } else {
                    Write-Host "[!] imei.ps1 not found." -ForegroundColor Red
                    Start-Sleep 2
                }
            }
            "2" {
                if (Test-Path ".\wifi_adb.ps1") {
                    . .\wifi_adb.ps1
                } else {
                    Write-Host "[!] wifi_adb.ps1 not found." -ForegroundColor Red
                    Start-Sleep 2
                }
            }
            "3" {
                if (Test-Path ".\stealth_mode.ps1") {
                    . .\stealth_mode.ps1
                } else {
                    Write-Host "[!] stealth_mode.ps1 not found." -ForegroundColor Red
                    Start-Sleep 2
                }
            }
            "0" {
                break
            }
            default {
                Write-Host "❗ Invalid choice. Try again." -ForegroundColor Yellow
                Start-Sleep 1.5
            }
        }
    }
}
