# Setting Up Wallet with Private Key

Your private key: `iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9`

## Option 1: Using IOTA CLI (Recommended)

### Step 1: Install IOTA CLI (if not already installed)
```bash
source "$HOME/.cargo/env"
cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota
```

This may take 10-15 minutes. Once installed, continue below.

### Step 2: Import Private Key
```bash
iota keytool import iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9 ed25519 --alias tanglearb_wallet
```

### Step 3: Get Address
```bash
iota keytool address --alias tanglearb_wallet
```

### Step 4: Request Faucet Tokens
Visit: https://faucet.testnet.iota.org/

Enter your address from Step 3.

## Option 2: Using Web Faucet Directly

1. **Derive Address from Private Key:**
   - You can use IOTA tools or libraries to derive the address
   - Or use the IOTA CLI method above

2. **Request Tokens:**
   - Go to: https://faucet.testnet.iota.org/
   - Enter your derived address
   - Request testnet tokens

## Option 3: Quick Script

Run the provided script:
```bash
cd /home/localhost/Desktop/TangleArb
./get_faucet_tokens.sh
```

## Using the Private Key with the Bot

Once you have the address and faucet tokens, you can:

1. **Convert private key to mnemonic** (if needed by IOTA SDK)
2. **Or use the private key directly** (if SDK supports it)

The bot currently supports:
- `--seed "mnemonic phrase"` - for mnemonic seed phrases
- `--private-key "key"` - placeholder (may need SDK update)

## Next Steps

After getting faucet tokens:
1. Build and publish Move package
2. Initialize vault
3. Run bot with package ID and vault object ID

