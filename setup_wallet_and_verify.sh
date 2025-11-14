#!/bin/bash

# Script to import private key (which already has testnet tokens) and verify balance
# Private Key: iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9

PRIVATE_KEY="iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9"
ALIAS="tanglearb_wallet"

echo "🔑 Setting up wallet with private key (already has testnet tokens)..."
echo ""

# Source cargo environment
source "$HOME/.cargo/env" 2>/dev/null || true

# Check if IOTA CLI is installed
if ! command -v iota &> /dev/null; then
    echo "⏳ IOTA CLI not yet installed. Checking installation status..."
    if ps aux | grep -q "cargo install.*iota"; then
        echo "   Installation in progress. Please wait..."
        echo "   This script will work once installation completes."
        exit 0
    else
        echo "❌ IOTA CLI not found. Please install it first:"
        echo "   cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota"
        exit 1
    fi
fi

echo "✅ IOTA CLI found: $(iota --version)"
echo ""

echo "📝 Step 1: Importing private key..."
iota keytool import "$PRIVATE_KEY" ed25519 --alias "$ALIAS" 2>&1

if [ $? -ne 0 ]; then
    echo "⚠️  Key may already be imported, or there was an error."
    echo "   Continuing..."
fi

echo ""
echo "📝 Step 2: Getting address..."
ADDRESS=$(iota keytool address --alias "$ALIAS" 2>/dev/null | grep -i "address" | head -1 | awk '{print $2}')

if [ -z "$ADDRESS" ]; then
    # Try alternative method
    ADDRESS=$(iota keytool list 2>/dev/null | grep -A 5 "$ALIAS" | grep -i "address" | head -1 | awk '{print $2}')
fi

if [ -z "$ADDRESS" ]; then
    echo "⚠️  Could not automatically get address."
    echo "   Try manually: iota keytool list"
    exit 1
fi

echo "✅ Address: $ADDRESS"
echo ""

echo "📝 Step 3: Checking balance..."
echo "   (This may take a moment to connect to testnet...)"
BALANCE=$(iota client balance --address "$ADDRESS" 2>&1 || iota wallet balance 2>&1)

echo "$BALANCE"
echo ""

echo "✅ Wallet setup complete!"
echo "   Address: $ADDRESS"
echo "   Alias: $ALIAS"
echo ""
echo "📦 Ready to build and publish Move package!"
echo "   Run: iota move build"
echo "   Then: iota move publish --network testnet"

