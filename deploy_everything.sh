#!/bin/bash

# Complete TangleArb Deployment Script
# This script handles the entire deployment process

set -e

PRIVATE_KEY="iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9"
ALIAS="tanglearb_wallet"
PROJECT_DIR="/home/localhost/Desktop/TangleArb"

cd "$PROJECT_DIR"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         TangleArb Complete Deployment Script                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Source cargo environment
source "$HOME/.cargo/env" 2>/dev/null || true
export PATH="$HOME/.cargo/bin:$PATH"

# Step 1: Check IOTA CLI
echo "📦 Step 1: Checking IOTA CLI..."
if ! command -v iota &> /dev/null; then
    echo "   ❌ IOTA CLI not found. Installing..."
    cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota
    if [ $? -ne 0 ]; then
        echo "   ❌ IOTA CLI installation failed!"
        exit 1
    fi
    export PATH="$HOME/.cargo/bin:$PATH"
else
    echo "   ✅ IOTA CLI found: $(iota --version 2>&1 | head -1)"
fi
echo ""

# Step 2: Import Private Key
echo "🔑 Step 2: Importing private key..."
iota keytool import "$PRIVATE_KEY" ed25519 --alias "$ALIAS" 2>&1 || echo "   (Key may already be imported)"
echo ""

# Step 3: Get Address
echo "📍 Step 3: Getting wallet address..."
ADDRESS=$(iota keytool address --alias "$ALIAS" 2>&1 | grep -i "address" | head -1 | awk '{print $2}')
if [ -z "$ADDRESS" ]; then
    ADDRESS=$(iota keytool list 2>/dev/null | grep -A 5 "$ALIAS" | grep -i "address" | head -1 | awk '{print $2}')
fi

if [ -z "$ADDRESS" ]; then
    echo "   ⚠️  Could not get address automatically"
    echo "   Please run manually: iota keytool list"
    exit 1
fi

echo "   ✅ Address: $ADDRESS"
echo ""

# Step 4: Verify Balance
echo "💰 Step 4: Verifying balance..."
BALANCE=$(iota client balance --address "$ADDRESS" 2>&1 || iota wallet balance 2>&1)
echo "$BALANCE"
echo ""

# Step 5: Build Move Package
echo "🔨 Step 5: Building Move package..."
cd "$PROJECT_DIR"
iota move build
if [ $? -ne 0 ]; then
    echo "   ❌ Move package build failed!"
    exit 1
fi
echo "   ✅ Build successful!"
echo ""

# Step 6: Publish Move Package
echo "📤 Step 6: Publishing Move package to testnet..."
PACKAGE_OUTPUT=$(iota move publish --network testnet 2>&1)
echo "$PACKAGE_OUTPUT"

# Extract Package ID
PACKAGE_ID=$(echo "$PACKAGE_OUTPUT" | grep -i "package id\|package_id\|Package ID" | head -1 | grep -oE "0x[a-fA-F0-9]{64}" | head -1)

if [ -z "$PACKAGE_ID" ]; then
    PACKAGE_ID=$(echo "$PACKAGE_OUTPUT" | grep -oE "0x[a-fA-F0-9]{64}" | head -1)
fi

if [ -z "$PACKAGE_ID" ]; then
    echo "   ⚠️  Could not extract Package ID automatically"
    echo "   Please copy it from the output above"
    read -p "   Enter Package ID: " PACKAGE_ID
else
    echo "   ✅ Package ID: $PACKAGE_ID"
fi

echo ""
echo "📝 Saving Package ID to package_id.txt..."
echo "$PACKAGE_ID" > "$PROJECT_DIR/package_id.txt"
echo ""

# Step 7: Initialize Vault
echo "🏦 Step 7: Initializing vault..."
echo "   This step may require manual intervention or a script"
echo "   Once vault is initialized, save the Vault Object ID"
echo ""

# Step 8: Build Bot
echo "🤖 Step 8: Building bot (release)..."
cd "$PROJECT_DIR/tanglearb-bot"
cargo build --release
if [ $? -ne 0 ]; then
    echo "   ❌ Bot build failed!"
    exit 1
fi
echo "   ✅ Bot built successfully!"
echo ""

# Summary
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    Deployment Summary                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ IOTA CLI: Installed"
echo "✅ Wallet: Imported ($ALIAS)"
echo "✅ Address: $ADDRESS"
echo "✅ Move Package: Built"
echo "✅ Move Package: Published"
echo "✅ Package ID: $PACKAGE_ID (saved to package_id.txt)"
echo "✅ Bot: Built (release)"
echo ""
echo "📋 Next Steps:"
echo "   1. Initialize vault and get Vault Object ID"
echo "   2. Run bot with:"
echo "      cd $PROJECT_DIR/tanglearb-bot"
echo "      ./target/release/tanglearb-bot \\"
echo "        --package-id $PACKAGE_ID \\"
echo "        --vault-object-id <VAULT_OBJECT_ID> \\"
echo "        --private-key $PRIVATE_KEY"
echo ""
echo "   3. Run frontend:"
echo "      cd $PROJECT_DIR"
echo "      pnpm dev"
echo ""

