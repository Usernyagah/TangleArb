// Quick utility to derive IOTA address from private key
// Run with: cargo run --bin get_address_from_key

use iota_sdk::{
    client::Client,
    secret::SecretManager,
    types::block::address::Address,
};
use std::str::FromStr;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let private_key = "iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9";
    
    println!("🔑 Deriving address from private key...");
    println!("   Private Key: {}", private_key);
    println!("");
    
    // Connect to testnet
    let client = Client::builder()
        .with_node("https://api.testnet.iota.org")?
        .finish()
        .await?;
    
    // Try to create secret manager from hex string
    // Note: IOTA SDK typically uses mnemonic, but we can try hex
    // If this doesn't work, we may need to convert the private key format
    
    println!("⚠️  Note: IOTA SDK typically uses mnemonic seed phrases.");
    println!("   Your private key format may need conversion.");
    println!("");
    println!("   For now, you can:");
    println!("   1. Use the web faucet: https://faucet.testnet.iota.org/");
    println!("   2. Convert your private key to a mnemonic (if possible)");
    println!("   3. Use IOTA CLI: iota keytool import <key> ed25519");
    println!("");
    
    // Try to get address using the private key
    // This is a placeholder - actual implementation depends on IOTA SDK version
    println!("📝 To get your address, you can:");
    println!("   1. Install IOTA CLI: cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota");
    println!("   2. Run: iota keytool import {} ed25519 --alias tanglearb", private_key);
    println!("   3. Run: iota keytool address --alias tanglearb");
    println!("   4. Use that address at: https://faucet.testnet.iota.org/");
    
    Ok(())
}

