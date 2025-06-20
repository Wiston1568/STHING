# 🛡️ STHING – Android Security Toolkit (Hybrid Edition)

**STHING** is a cross-platform Android security toolkit built for bug bounty hunters, red teamers, and mobile security researchers.  
It works on **Windows** (offline capable) and **Linux** (PowerShell Core) and features real ADB-based logic for MDM detection, root status, IMEI analysis, and Magisk installation.

---

## ⚙️ Features

- 🔍 Advanced MDM Detection (Knox, Intune, AirWatch, etc.)
- 💀 MDM Removal (requires root)
- 📱 IMEI Reader & Spoof Detection
- 🔓 Root Status + Magisk Detection
- 🧠 Full Auto Mode (runs all checks)
- 🧱 Magisk Manager Installer
- 🔬 Chipset + Device Info Scanner
- ✅ Works fully offline on Windows with built-in ADB

---

## 🚀 Windows (PowerShell) — Quick Launch

### ▶️ One-Liner Method (Recommended)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex (iwr -UseBasicParsing 'https://raw.githubusercontent.com/wiston1568/STTHING/main/start.ps1')

✅ This will:

    Download and run sththing.exe (if available)

    Or fall back to run.ps1 + included adb.exe

🖱️ Manual Windows Usage

    Download the repo or clone it:

git clone https://github.com/Wiston1568/STTHING
cd STHING

    Run from PowerShell:

powershell -ExecutionPolicy Bypass -File start.ps1

    Or just double-click STTHING.bat

✅ No installation needed — ADB is bundled for offline use.
🐧 Linux Install & Use (PowerShell Core)
🔧 Step 1: Install ADB

sudo apt install android-tools-adb

🔧 Step 2: Install PowerShell Core

sudo apt install powershell

🔧 Step 3: Clone and Run

git clone https://github.com/Wiston1568/STTHING
cd STHING
pwsh ./run.ps1

✅ Works on Kali, Ubuntu, Parrot, Arch, and more.
🛠️ Modify run.ps1 for Linux ADB (Required!)

If you're running on Linux, change every ADB line in run.ps1 from:

& .\adb.exe shell ...

To:

& adb shell ...


