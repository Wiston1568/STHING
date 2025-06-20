[![Run in PowerShell](https://img.shields.io/badge/Run%20STHING%20in%20PowerShell-blue?logo=powershell)](https://aka.ms/pscore6)

# STHING Security Toolkit 🛡️
> Dev by Bug & wiston1568  
> Version: 1.0 | PowerShell + Rust | Cross-platform Android Tool

---

## ⚙️ Features

- 🔍 Detect & Remove MDM Locks
- 🔐 IMEI Reader & Spoofer
- ⚠️ Smart Root Detection
- 🔧 Chipset & Device Info Scanner
- 🧠 Full Auto Mode (MDM & Root)
- 📦 Magisk Manager Installer

---

## 🖥️ How to Run (Windows)

1. **Connect your Android device**
2. **Enable USB Debugging**
3. **Double-click `sthing_launcher.exe`**
4. 🧠 Follow the on-screen PowerShell menu

> Make sure ADB drivers are installed or include `adb.exe` with the files.

---

## 📂 File Structure

STHING/
├── run.ps1 # The main PowerShell tool
├── sthing_launcher.exe # Native Windows launcher (.exe)
├── adb/
│ ├── adb.exe
│ ├── AdbWinApi.dll
│ ├── AdbWinUsbApi.dll

yaml
Copy
Edit

---

## ✅ Requirements

- Windows 10/11 with PowerShell
- Android phone with ADB enabled
- No root required for detection; root required for MDM removal

---

## 📦 To Build the Native EXE Yourself (optional)

Install Rust: https://rustup.rs

Then run:
```sh
cargo build --release
🔒 Legal Disclaimer
This tool is for educational and authorized testing only.
You are responsible for your actions when using this tool.

yaml
Copy
Edit

---

### ✅ Next Step

I'll now finish preparing the real `sthing_launcher.exe`. Would you like me to simulate the GitHub folder as a downloadable zip with placeholders so you can upload it right away?










