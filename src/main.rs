mod imei;
mod mdm;
mod root;
mod ui;
mod utils;

use crate::utils::*;
use std::io;

fn main() {
    loop {
        ui::print_banner();
        ui::print_menu();

        let mut choice = String::new();
        io::stdin()
            .read_line(&mut choice)
            .expect("Failed to read input");

        match choice.trim() {
            "1" => mdm::detect_mdm(),
            "2" => mdm::remove_mdm(),
            "3" => {
                let info = scan_device_info();
                let new_imei = imei::generate_imei(&info.original_imei);
                imei::spoof_imei(&info.chipset, &new_imei);
            }
            "4" => root::attempt_root(),
            "5" => run_auto_mode(),
            "6" => {
                let info = scan_device_info();
                imei::restore_original_imei(&info.chipset, &info.original_imei);
            }
            "7" => {
                let info = scan_device_info();
                println!("🔬 Detected chipset: {}", info.chipset);
            }
            "8" => {
                let info = scan_device_info();
                println!("{:?}", info);
            }
            "9" => {
                if smart_root_detect() {
                    println!("✅ Device is rooted.");
                } else {
                    println!("❌ Device is not rooted.");
                }
            }
            "0" => break,
            _ => println!("❌ Invalid option"),
        }
    }
}
