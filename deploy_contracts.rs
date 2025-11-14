// Quick deployment script using IOTA SDK
// Run with: cargo run --bin deploy_contracts

use iota_sdk::{
    client::Client,
    secret::SecretManager,
    wallet::Wallet,
};
use std::fs;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let private_key = "iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9";
    
    println!("🚀 Deploying TangleArb contracts to IOTA testnet...");
    
    // Connect to testnet
    let client = Client::builder()
        .with_node("https://api.testnet.iota.org")?
        .finish()
        .await?;
    
    println!("✅ Connected to testnet");
    
    // Initialize wallet
    let secret_manager = SecretManager::try_from_mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about")?;
    
    let wallet = Wallet::builder()
        .with_secret_manager(secret_manager)
        .finish()
        .await?;
    
    let account = wallet.get_or_create_account("TangleArb").await?;
    
    println!("✅ Wallet initialized");
    
    // Read Move package
    let move_toml = fs::read_to_string("Move.toml")?;
    println!("✅ Move.toml loaded");
    
    // Note: IOTA SDK MoveVM publishing API may vary
    // This is a placeholder - actual API needs to be confirmed
    println!("⚠️  MoveVM publishing via SDK needs IOTA SDK MoveVM API");
    println!("   Package location: /home/localhost/Desktop/TangleArb");
    println!("   Use IOTA CLI once ready: iota move publish --network testnet");
    
    Ok(())
}

