# Quick Start with Private Key (Already Has Testnet Tokens)

Your private key already has testnet faucet tokens, so we can skip the faucet request step!

**Private Key:** `iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9`

## Step 1: Wait for IOTA CLI Installation

The IOTA CLI is currently installing. Check status:
```bash
ps aux | grep "cargo install.*iota"
```

Once installed, verify:
```bash
source "$HOME/.cargo/env"
iota --version
```

## Step 2: Import Private Key and Verify Balance

Once IOTA CLI is ready, run:
```bash
cd /home/localhost/Desktop/TangleArb
./setup_wallet_and_verify.sh
```

Or manually:
```bash
source "$HOME/.cargo/env"
iota keytool import iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9 ed25519 --alias tanglearb_wallet
iota keytool address --alias tanglearb_wallet
iota client balance --address <YOUR_ADDRESS>
```

## Step 3: Build Move Package

```bash
cd /home/localhost/Desktop/TangleArb
iota move build
```

## Step 4: Publish Move Package to Testnet

```bash
iota move publish --network testnet
```

**Important:** Copy the **Package ID** from the output!

## Step 5: Initialize Vault

After publishing, you need to initialize a vault. This can be done via:
- IOTA CLI (if supported)
- A script using IOTA SDK
- Or manually through the frontend

Get the **Vault Object ID** from the initialization transaction.

## Step 6: Run Bot

```bash
cd /home/localhost/Desktop/TangleArb/tanglearb-bot
source "$HOME/.cargo/env"
cargo build --release
./target/release/tanglearb-bot \
  --package-id <YOUR_PACKAGE_ID> \
  --vault-object-id <YOUR_VAULT_OBJECT_ID> \
  --private-key iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9
```

**Note:** The bot currently has a placeholder for MoveVM API calls. Once the package is published, we'll need to update the bot code with the correct IOTA SDK MoveVM API.

## Step 7: Run Frontend

```bash
cd /home/localhost/Desktop/TangleArb
pnpm dev
```

Open http://localhost:3000

## Current Status

- ✅ Rust installed
- ✅ Bot compiles
- ✅ Frontend dependencies installed
- ⏳ IOTA CLI installing (check with `ps aux | grep "cargo install.*iota"`)
- ⏳ Wallet setup (waiting for IOTA CLI)
- ⏳ Move package build/publish (waiting for IOTA CLI)

