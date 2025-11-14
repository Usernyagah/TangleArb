#!/bin/bash
# Complete TangleArb Submission - Automated Script

set -e

PRIVATE_KEY="iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9"
PROJECT_DIR="/home/localhost/Desktop/TangleArb"

cd "$PROJECT_DIR"
source "$HOME/.cargo/env" 2>/dev/null || true
export PATH="$HOME/.cargo/bin:$PATH"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     TangleArb - Complete Submission Automation             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Wait for IOTA CLI if needed
if ! command -v iota &> /dev/null; then
    echo "⏳ Waiting for IOTA CLI installation..."
    while ! command -v iota &> /dev/null; do
        if ! ps aux | grep -q "[c]argo install.*iota"; then
            echo "   Installing IOTA CLI..."
            cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota &
        fi
        sleep 10
        export PATH="$HOME/.cargo/bin:$PATH"
    done
fi

echo "✅ IOTA CLI ready: $(iota --version 2>&1 | head -1)"
echo ""

# Import key
echo "🔑 Importing private key..."
iota keytool import "$PRIVATE_KEY" ed25519 --alias tanglearb_wallet 2>&1 || true

# Get address
ADDRESS=$(iota keytool address --alias tanglearb_wallet 2>&1 | grep -i "address" | head -1 | awk '{print $2}' || echo "")
echo "📍 Address: $ADDRESS"
echo ""

# Build Move package
echo "🔨 Building Move package..."
iota move build
echo "✅ Build complete!"
echo ""

# Publish
echo "📤 Publishing to testnet..."
PACKAGE_OUTPUT=$(iota move publish --network testnet 2>&1)
echo "$PACKAGE_OUTPUT"

PACKAGE_ID=$(echo "$PACKAGE_OUTPUT" | grep -oE "0x[a-fA-F0-9]{64}" | head -1 || echo "")
if [ -n "$PACKAGE_ID" ]; then
    echo "$PACKAGE_ID" > package_id.txt
    echo "✅ Package ID saved: $PACKAGE_ID"
else
    echo "⚠️  Please extract Package ID manually from output above"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    READY FOR SUBMISSION                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📦 Package ID: $PACKAGE_ID"
echo "📍 Address: $ADDRESS"
echo ""
echo "📋 Next Steps:"
echo "   1. Initialize vault (get Vault Object ID)"
echo "   2. Record demo video"
echo "   3. Submit to Moveathon Europe"
echo ""

