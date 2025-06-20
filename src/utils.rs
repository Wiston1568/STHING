use colored::*;
use std::process::Command;

#[derive(Debug)]
pub struct DeviceInfo {
    pub manufacturer: String,
    pub model: String,
    pub android_version: String,
    pub chipset: String,
    pub original_imei: String,
}

pub fn scan_device_info() -> DeviceInfo {
    println!("{}", "📡 Scanning device info...".cyan());

    let manufacturer = get_prop("ro.product.manufacturer").unwrap_or("Unknown".to_string());
    let model = get_prop("ro.product.model").unwrap_or("Unknown".to_string());
    let android_version = get_prop("ro.build.version.release").unwrap_or("Unknown".to_string());
    let chipset = detect_chipset();
    let original_imei = get_dummy_imei();

    println!(
        "{}: {} {} running Android {}",
        "📱 Device".bright_cyan(),
        manufacturer,
        model,
        android_version
    );

    DeviceInfo {
        manufacturer,
        model,
        android_version,
        chipset,
        original_imei,
    }
}

fn get_prop(prop: &str) -> Option<String> {
    let output = Command::new("adb")
        .arg("shell")
        .arg("getprop")
        .arg(prop)
        .output()
        .ok()?;
    let result = String::from_utf8_lossy(&output.stdout).trim().to_string();
    if result.is_empty() {
        None
    } else {
        Some(result)
    }
}

fn detect_chipset() -> String {
    let cpuinfo = Command::new("adb")
        .arg("shell")
        .arg("cat /proc/cpuinfo")
        .output()
        .ok()
        .map(|o| String::from_utf8_lossy(&o.stdout).to_lowercase())
        .unwrap_or_default();

    if cpuinfo.contains("mt") || cpuinfo.contains("mediatek") {
        "mediatek".to_string()
    } else if cpuinfo.contains("exynos") {
        "exynos".to_string()
    } else if cpuinfo.contains("qcom") || cpuinfo.contains("snapdragon") {
        "snapdragon".to_string()
    } else {
        "unknown".to_string()
    }
}

fn get_dummy_imei() -> String {
    "351756789012345".to_string()
}

pub fn smart_root_detect() -> bool {
    println!("{}", "🔍 Performing smart root detection...".yellow());

    let output = Command::new("which").arg("su").output();
    output.map(|o| o.status.success()).unwrap_or(false)
}

pub fn run_auto_mode() {
    println!("{}", "🧠 Running Full Auto Mode...".bright_purple());

    let info = scan_device_info();
    let rooted = smart_root_detect();

    if !rooted {
        println!("{}", "⚡ Device not rooted. Attempting root...".yellow());
        crate::root::attempt_root();
    } else {
        println!("{}", "✅ Device already rooted.".green());
    }

    println!("{}", "📱 Spoofing IMEI...".magenta());
    let new_imei = crate::imei::generate_imei(&info.original_imei);
    crate::imei::spoof_imei(&info.chipset, &new_imei);

    println!("{}", "💀 Running MDM removal...".red());
    crate::mdm::remove_mdm();

    println!("{}", "✅ Full Auto Mode complete.".green());
}
