use colored::*;
use std::process::Command;

pub fn detect_mdm() {
    println!("{}", "🔍 Detecting MDMs...".yellow());

    let output = Command::new("adb")
        .arg("shell")
        .arg("pm list packages")
        .output()
        .expect("Failed to execute adb");

    let output_str = String::from_utf8_lossy(&output.stdout);
    let suspicious = [
        "mdm",
        "airwatch",
        "devicepolicy",
        "soti",
        "hexnode",
        "suremdm",
    ];

    for line in output_str.lines() {
        if suspicious.iter().any(|&k| line.contains(k)) {
            println!("⚠️ MDM package found: {}", line.trim());
        }
    }
}

pub fn remove_mdm() {
    println!("{}", "💀 Attempting to remove MDMs...".red());

    let known = [
        "com.android.devicepolicy",
        "com.soti.mobicontrol",
        "com.airwatch.androidagent",
        "com.hexnode.mdm",
        "com.manageengine.mdm",
        "com.suremdm.agent",
    ];

    for pkg in known.iter() {
        let _ = Command::new("adb")
            .arg("shell")
            .arg("pm uninstall --user 0")
            .arg(pkg)
            .output();
        let _ = Command::new("adb")
            .arg("shell")
            .arg("pm disable-user")
            .arg(pkg)
            .output();
    }

    // Kill MDM-related processes
    let _ = Command::new("adb")
        .arg("shell")
        .arg("pkill -f mdm")
        .output();

    // Modify hosts file to block MDM reinstallation domains
    let block_domains = [
        "mdm.samsung.com",
        "mdm.xiaomi.com",
        "airwatch.com",
        "soti.net",
        "manageengine.com",
    ];

    let mut hosts_cmd = Command::new("adb");
    for domain in block_domains.iter() {
        let entry = format!("127.0.0.1 {}\n", domain);
        let _ = hosts_cmd
            .arg("shell")
            .arg(format!("echo '{}' >> /system/etc/hosts", entry));
    }

    println!("{}", "✅ MDM removal attempt complete.".green());
}
