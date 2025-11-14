# TangleArb Setup Status

## ✅ Completed

1. **Rust Installed** - Rust 1.91.1 is installed and ready
2. **Node.js Installed** - v22.19.0 is installed
3. **Bot Code Updated** - Added support for `--private-key` flag
4. **Scripts Created** - `get_faucet_tokens.sh` for faucet setup

## ⏳ In Progress / Next Steps

### 1. Install IOTA CLI (Required - Takes 10-15 minutes)

```bash
source "$HOME/.cargo/env"
cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota
```

**Your Private Key:** `iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9`

### 2. Once IOTA CLI is Installed, Run:

```bash
cd /home/localhost/Desktop/TangleArb
./get_faucet_tokens.sh
```

This will:
- Import your private key
- Derive your IOTA testnet address
- Show you where to request faucet tokens

### 3. Get Faucet Tokens

**Option A: Using IOTA CLI (after installation)**
```bash
iota keytool import iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9 ed25519 --alias tanglearb_wallet
iota keytool address --alias tanglearb_wallet
# Then visit: https://faucet.testnet.iota.org/
```

**Option B: Web Faucet (if you can derive address another way)**
- Visit: https://faucet.testnet.iota.org/
- Enter your address
- Request tokens

### 4. Build and Publish Move Package

```bash
cd /home/localhost/Desktop/TangleArb
iota move build
iota move publish --network testnet
```

### 5. Initialize Vault

After publishing, initialize a vault and get the vault object ID.

### 6. Build and Run Bot

```bash
cd tanglearb-bot
source "$HOME/.cargo/env"
cargo build --release
./target/release/tanglearb-bot \
  --package-id <YOUR_PACKAGE_ID> \
  --vault-object-id <YOUR_VAULT_OBJECT_ID> \
  --private-key iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9
```

## 📝 Files Created

- `get_faucet_tokens.sh` - Script to import key and get address
- `PRIVATE_KEY_SETUP.md` - Detailed setup instructions
- `SETUP_STATUS.md` - This file

## 🔧 Current Issues

1. **IOTA CLI not installed** - Installation in progress or needs to be started
2. **Bot dependencies** - May need API adjustments for IOTA SDK 1.0
3. **Move package** - Needs IOTA CLI to build/publish

## 🎯 Quick Start (Once IOTA CLI is Ready)

```bash
# 1. Get address and faucet tokens
./get_faucet_tokens.sh

# 2. Build Move package
iota move build

# 3. Publish to testnet
iota move publish --network testnet

# 4. Initialize vault (get object ID)

# 5. Run bot
cd tanglearb-bot
cargo build --release
./target/release/tanglearb-bot --package-id <ID> --vault-object-id <ID> --private-key iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9
```

