# 🛡️ STHING – Android Security Toolkit

> **Dev by Bug & wiston1568**

STHING is a full-featured Rust-based Android security toolkit that operates entirely through your terminal. It supports advanced MDM detection, IMEI spoofing, root checking, and more — all packed into a fast, native command-line experience.

---

## 🔧 Features

- 🔍 **Advanced MDM Detection**
  - Detects known and hidden MDM packages
  - Device owner and policy scanner
- 💀 **MDM Removal (Root Only)**
  - Forcefully uninstalls and blocks MDM reinstall attempts
  - Supports Samsung Knox, Xiaomi Remote Management, etc.
- 📱 **IMEI Spoofing**
  - Chipset-aware spoofing (e.g., Qualcomm/MediaTek)
  - Generates random but valid IMEIs
- 🔁 **Restore IMEI**
  - Backup and revert to original IMEI
- ⚡ **Root Simulation / Root Detection**
  - Smart detection of root status
  - Optional simulated root environment
- 🧠 **Full Auto Mode**
  - Automatically runs detection, spoofing, and MDM cleanup
- 🔬 **Chipset & Device Info Scanner**
  - Detects manufacturer, model, Android version, and chipset
- 🔓 **Smart Root Suggestions**
  - Suggests best rooting method if device is not rooted

---

## 📥 Installation & Usage

### 🐧 Linux – From Source

```bash
# Install Rust and Git if you haven't:
sudo apt install git curl -y
curl https://sh.rustup.rs -sSf | sh

# Clone and build
git clone https://github.com/wiston1568/STHING.git
cd STHING
cargo build --release
./target/release/sththing
wget https://github.com/wiston1568/STHING/raw/main/sththing
chmod +x sththing
./sththing
Set-ExecutionPolicy Bypass -Scope Process -Force
iex (iwr -UseBasicParsing 'https://raw.githubusercontent.com/wiston1568/STHING/main/run.ps1')
