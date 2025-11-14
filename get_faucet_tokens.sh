#!/bin/bash

# Script to get IOTA testnet address from private key and request faucet tokens
# Private Key: iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9

PRIVATE_KEY="iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9"

echo "🔑 Using Private Key: $PRIVATE_KEY"
echo ""

# Check if IOTA CLI is installed
if ! command -v iota &> /dev/null; then
    echo "❌ IOTA CLI not found. Installing..."
    echo "   Run: cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota"
    echo ""
    echo "   Or use the web faucet directly:"
    echo "   https://faucet.testnet.iota.org/"
    echo ""
    echo "   You'll need to derive the address from your private key first."
    exit 1
fi

echo "📝 Step 1: Importing private key..."
iota keytool import "$PRIVATE_KEY" ed25519 --alias tanglearb_wallet 2>&1

if [ $? -ne 0 ]; then
    echo "⚠️  Key import may have failed. Trying alternative method..."
    echo ""
fi

echo ""
echo "📝 Step 2: Getting address..."
ADDRESS=$(iota keytool address --alias tanglearb_wallet 2>/dev/null | grep -i "address" | head -1 | awk '{print $2}')

if [ -z "$ADDRESS" ]; then
    echo "⚠️  Could not get address from CLI. Trying to derive manually..."
    echo ""
    echo "   You can manually request faucet tokens at:"
    echo "   https://faucet.testnet.iota.org/"
    echo ""
    echo "   Or use IOTA SDK to derive the address programmatically."
else
    echo "✅ Address: $ADDRESS"
    echo ""
    echo "📝 Step 3: Requesting faucet tokens..."
    echo "   Visit: https://faucet.testnet.iota.org/"
    echo "   Enter address: $ADDRESS"
    echo ""
    echo "   Or use CLI (if supported):"
    iota client faucet --address "$ADDRESS" 2>&1 || echo "   CLI faucet command not available, use web faucet"
fi

echo ""
echo "✅ Done! Your address is ready for faucet tokens."
echo "   Address: $ADDRESS"
echo "   Faucet: https://faucet.testnet.iota.org/"

