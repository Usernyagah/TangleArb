use anyhow::{Context, Result};
use clap::Parser;
use iota_sdk::{
    client::{
        Client,
        secret::SecretManager,
    },
    types::block::BlockId,
    wallet::{
        account::Account,
        Wallet,
    },
};
use rand::Rng;
use std::time::Duration;
use tokio::time::{sleep, interval};

#[derive(Parser, Debug)]
#[command(name = "tanglearb-bot")]
#[command(about = "TangleArb arbitrage bot that executes dummy arbitrage opportunities")]
struct Args {
    /// Published package ID (e.g., 0x1234...)
    #[arg(long)]
    package_id: String,

    /// Vault object ID (e.g., 0x5678...)
    #[arg(long)]
    vault_object_id: String,

    /// Optional: Secret manager seed phrase (if not provided, will use placeholder)
    #[arg(long)]
    seed: Option<String>,

    /// Optional: Private key (hex format)
    #[arg(long)]
    private_key: Option<String>,
}

struct BotState {
    client: Client,
    account: Account,
    package_id: String,
    vault_object_id: String,
}

impl BotState {
    async fn new(args: Args) -> Result<Self> {
        // Initialize wallet with secret manager
        let secret_manager = if let Some(seed) = &args.seed {
            SecretManager::try_from_mnemonic(seed.as_str())?
        } else if let Some(_private_key) = &args.private_key {
            // Try to create from hex private key
            // Note: IOTA SDK may require mnemonic, so this might need adjustment
            println!("⚠️  Using private key (may need conversion to mnemonic)");
            // For now, fall back to placeholder - private key support depends on SDK version
            SecretManager::try_from_mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about")?
        } else {
            // Use a placeholder seed for testing (in production, use proper secret management)
            SecretManager::try_from_mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about")?
        };

        // Create wallet - it will create its own client connection to testnet
        let wallet = Wallet::builder()
            .with_secret_manager(secret_manager)
            .finish()
            .await?;

        // Get the client from wallet for later use
        let client = wallet.client().clone();

        // Get or create account
        let account = wallet
            .get_or_create_account("TangleArb Bot")
            .await?;

        Ok(Self {
            client,
            account,
            package_id: args.package_id,
            vault_object_id: args.vault_object_id,
        })
    }

    async fn execute_arbitrage(&self) -> Result<(BlockId, u64)> {
        // Generate random profit amount between 50_000_000 and 500_000_000 nanoIOTA
        let mut rng = rand::thread_rng();
        let profit_amount = rng.gen_range(50_000_000..=500_000_000);

        println!("🔍 Found arbitrage opportunity! Profit: {} nanoIOTA", profit_amount);

        // For MoveVM calls in IOTA 2.0, we need to build a transaction that calls the smart contract function
        // The function signature is: tanglearb::arb_executor::execute_dummy_arb(vault_object_id, profit_amount)
        
        // Use the account's transaction builder to create a MoveVM function call
        // The account's prepare_transaction() returns a builder that we can use to add MoveVM calls
        
        // Build the transaction with MoveVM function call
        // Note: The exact API may vary based on iota-sdk version
        // TODO: Update this with correct IOTA SDK MoveVM API once package is published
        // For now, this is a placeholder that will need to be updated
        
        // The MoveVM API in iota-sdk 1.1.5 may be different
        // This will need to be updated based on actual SDK documentation
        // Expected: Call tanglearb::arb_executor::execute_dummy_arb(vault_object_id, profit_amount)
        
        println!("⚠️  MoveVM function call API needs to be implemented");
        println!("   Package ID: {}", self.package_id);
        println!("   Vault Object ID: {}", self.vault_object_id);
        println!("   Function: arb_executor::execute_dummy_arb");
        println!("   Profit Amount: {} nanoIOTA", profit_amount);
        
        // Placeholder - this will need actual implementation
        // Once the Move package is published, we can test the correct API
        // TODO: Implement actual MoveVM call once API is confirmed
        // Example (may need adjustment):
        // let block_id = self.account
        //     .call_move_function(
        //         &self.package_id,
        //         "arb_executor",
        //         "execute_dummy_arb",
        //         vec![...],
        //     )
        //     .await?;
        
        // For now, return an error indicating API needs implementation
        Err(anyhow::anyhow!("MoveVM API not yet implemented - needs IOTA SDK MoveVM function call method. Package ID: {}, Vault: {}, Profit: {}", 
            self.package_id, self.vault_object_id, profit_amount))
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let args = Args::parse();

    println!("🚀 Starting TangleArb Bot...");
    println!("📦 Package ID: {}", args.package_id);
    println!("🏦 Vault Object ID: {}", args.vault_object_id);
    println!("🌐 Connecting to IOTA testnet...");

    let bot = BotState::new(args)
        .await
        .context("Failed to initialize bot")?;

    println!("✅ Connected to IOTA testnet!");
    println!("⏰ Starting arbitrage loop (every 15 seconds)...\n");

    let mut interval = interval(Duration::from_secs(15));
    let mut attempt_count = 0u64;

    loop {
        interval.tick().await;
        attempt_count += 1;

        println!("[Attempt #{}] Searching for arbitrage opportunity...", attempt_count);

        // Retry logic with exponential backoff
        let mut retry_count = 0;
        const MAX_RETRIES: u32 = 5;

        loop {
            match bot.execute_arbitrage().await {
                Ok((block_id, profit_amount)) => {
                    let profit_iota = profit_amount as f64 / 1_000_000_000.0;
                    println!(
                        "💰 Arbitrage executed successfully!\n   Block ID: {}\n   Profit: {} nanoIOTA ({:.9} IOTA)\n",
                        block_id, profit_amount, profit_iota
                    );
                    break;
                }
                Err(e) => {
                    retry_count += 1;
                    if retry_count >= MAX_RETRIES {
                        eprintln!("❌ Failed after {} retries: {}", MAX_RETRIES, e);
                        eprintln!("   Continuing to next cycle...\n");
                        break;
                    }

                    let backoff = 2_u64.pow(retry_count);
                    eprintln!("⚠️  Error (attempt {}/{}): {}", retry_count, MAX_RETRIES, e);
                    eprintln!("   Retrying in {} seconds...", backoff);
                    sleep(Duration::from_secs(backoff)).await;
                }
            }
        }
    }
}
