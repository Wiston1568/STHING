use colored::*;

pub fn print_banner() {
    println!("{}", "╔══════════════════════════════╗".bright_purple());
    println!("{}", "║     STHING Security Tool     ║".bright_purple());
    println!("{}", "║  Dev by Bug and wiston1568   ║".bright_purple());
    println!("{}", "╚══════════════════════════════╝".bright_purple());
}

pub fn print_menu() {
    println!("\n{}", "[ STHING :: Main Menu ]".bright_purple());
    println!("1. 🔍 Advanced MDM Detection");
    println!("2. 💀 Remove MDM (Root Only)");
    println!("3. 📱 Spoof IMEI");
    println!("4. ⚡ Root Device (if not already rooted)");
    println!("5. 🧠 Run Full Auto Mode");
    println!("6. 🔁 Restore Original IMEI");
    println!("7. 🔬 Detect Chipset");
    println!("8. 📡 Scan Device Info");
    println!("9. 🔓 Smart Root Detection + Suggestions");
    println!("0. ❌ Exit");
    print!("💬 Enter option: ");
}
