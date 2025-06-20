use colored::*;

pub fn generate_imei(original: &str) -> String {
    let mut new_imei = original.chars().rev().collect::<String>();
    new_imei.truncate(15);
    if new_imei == original {
        new_imei = "351756786543210".to_string();
    }
    new_imei
}

pub fn spoof_imei(chipset: &str, new_imei: &str) {
    println!("🔧 Spoofing IMEI to {} for chipset {}", new_imei, chipset);

    match chipset {
        "mediatek" => {
            let _ = std::process::Command::new("adb")
                .arg("shell")
                .arg("echo 'AT+EGMR=1,7,\"".to_string() + new_imei + "\"'")
                .output();
        }
        _ => println!("⚠️ IMEI spoofing not supported on this chipset."),
    }
}

pub fn restore_original_imei(chipset: &str, original_imei: &str) {
    println!(
        "🔁 Restoring original IMEI: {} on chipset {}",
        original_imei, chipset
    );

    match chipset {
        "mediatek" => {
            let _ = std::process::Command::new("adb")
                .arg("shell")
                .arg("echo 'AT+EGMR=1,7,\"".to_string() + original_imei + "\"'")
                .output();
        }
        _ => println!("⚠️ Restore not supported on this chipset."),
    }
}
