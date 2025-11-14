# TangleArb Bot

A Rust binary that automatically executes dummy arbitrage opportunities on the IOTA testnet by calling the `tanglearb::arb_executor::execute_dummy_arb` MoveVM function.

## Features

- ✅ Connects to IOTA testnet (https://api.testnet.iota.org)
- ✅ Finds fake arbitrage opportunities every 15 seconds
- ✅ Submits feeless, sponsored transactions
- ✅ Calls `tanglearb::arb_executor::execute_dummy_arb(vault_object_id, profit_amount)`
- ✅ Random profit amounts between 50,000,000 and 500,000,000 nanoIOTA
- ✅ Prints block ID and profit added
- ✅ Handles object mutability correctly
- ✅ Runs forever with proper error retry logic (exponential backoff)

## Prerequisites

- Rust 1.70+ installed
- Published package ID for your TangleArb contract
- Vault object ID

## Installation

```bash
cd tanglearb-bot
cargo build --release
```

## Usage

Run the bot with your package ID and vault object ID:

```bash
./target/release/tanglearb-bot \
  --package-id 0xYOUR_PACKAGE_ID \
  --vault-object-id 0xYOUR_VAULT_OBJECT_ID
```

### Optional: Custom Seed Phrase

You can optionally provide a seed phrase for the wallet:

```bash
./target/release/tanglearb-bot \
  --package-id 0xYOUR_PACKAGE_ID \
  --vault-object-id 0xYOUR_VAULT_OBJECT_ID \
  --seed "your twelve word seed phrase here"
```

If no seed is provided, a placeholder seed will be used (for testing only).

## How It Works

1. **Connection**: The bot connects to the IOTA testnet node
2. **Wallet Setup**: Creates or uses an existing wallet account
3. **Arbitrage Loop**: Every 15 seconds:
   - Generates a random profit amount (50M - 500M nanoIOTA)
   - Calls the MoveVM function `tanglearb::arb_executor::execute_dummy_arb`
   - Submits the transaction (feeless/sponsored)
   - Prints the block ID and profit amount
4. **Error Handling**: Implements exponential backoff retry logic (up to 5 retries)

## Output Example

```
🚀 Starting TangleArb Bot...
📦 Package ID: 0x1234...
🏦 Vault Object ID: 0x5678...
🌐 Connecting to IOTA testnet...
✅ Connected to IOTA testnet!
⏰ Starting arbitrage loop (every 15 seconds)...

[Attempt #1] Searching for arbitrage opportunity...
🔍 Found arbitrage opportunity! Profit: 234567890 nanoIOTA
✅ Transaction submitted! Block ID: 0xabc123...
💰 Arbitrage executed successfully!
   Block ID: 0xabc123...
   Profit: 234567890 nanoIOTA (0.234567890 IOTA)
```

## Notes

- The bot runs indefinitely until stopped (Ctrl+C)
- Transactions are feeless and sponsored
- Object mutability is handled automatically by the iota-sdk
- The bot will retry failed transactions with exponential backoff

## Troubleshooting

If you encounter API errors, the exact method names in `iota-sdk` may vary by version. Check the [iota-sdk documentation](https://iotaledger.github.io/iota/iota_sdk/index.html) for the correct API for MoveVM function calls in your version.

The key method that might need adjustment is `account.call_contract_function()` - refer to your iota-sdk version's documentation for the exact signature.

