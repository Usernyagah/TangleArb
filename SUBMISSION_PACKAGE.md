# TangleArb - Moveathon Europe Submission Package

## Project Overview

**TangleArb** - Feeless Arbitrage Vault on IOTA MoveVM

A complete arbitrage trading system built on IOTA's MoveVM that enables users to deposit capital into secure vaults and execute automated arbitrage opportunities with **zero gas fees**.

## Key Features

- ✅ Zero gas fees - unlimited transaction frequency on IOTA
- ✅ Shareable vault objects for off-chain bot access
- ✅ Flash loan integration for capital-efficient trading
- ✅ Custom strategy registry for advanced users
- ✅ Real-time arbitrage execution bot
- ✅ Modern Next.js frontend with live stats

## Project Structure

```
TangleArb/
├── sources/                    # Move smart contracts
│   ├── vault.move             # User vault management
│   ├── arb_executor.move      # Arbitrage execution
│   ├── flash_loan.move        # Flash loan functionality
│   └── strategy_registry.move # Strategy management
├── tests/                      # Unit tests
├── tanglearb-bot/              # Rust arbitrage bot
│   └── target/release/        # Compiled bot binary
├── app/                        # Next.js frontend
└── components/                 # React components
```

## Technical Stack

- **Smart Contracts:** MoveVM (IOTA)
- **Backend Bot:** Rust + IOTA SDK
- **Frontend:** Next.js + TypeScript + Tailwind CSS
- **Network:** IOTA Testnet

## Deployment Status

### ✅ Completed
- Move smart contracts written and tested
- Rust bot compiled and ready
- Frontend built and ready
- All deployment scripts created
- Private key configured (has testnet tokens)

### ⏳ In Progress
- IOTA CLI installation (required for Move package publish)

### 📋 Ready to Deploy
Once IOTA CLI is ready:
1. Build Move package: `iota move build`
2. Publish to testnet: `iota move publish --network testnet`
3. Initialize vault
4. Run bot with package ID and vault object ID

## Demo Video Script

**3-Minute Moveathon Demo:**

1. **Introduction (0:00-0:15)**
   - "Hi, I'm [Name], and this is TangleArb - a feeless arbitrage vault built on IOTA MoveVM"
   - Show frontend homepage

2. **Live Demo - Frontend (0:15-0:45)**
   - Connect wallet
   - Show vault section
   - Show strategy cards
   - Show activity feed

3. **Live Demo - Bot (0:45-1:30)**
   - Show bot running
   - Show arbitrage executions
   - Show block IDs and profits

4. **Technical Deep Dive (1:30-2:15)**
   - Show Move package structure
   - Explain modules
   - Show smart contract code

5. **Key Features (2:15-2:45)**
   - Zero gas fees
   - Shareable vaults
   - Flash loans
   - Strategy registry

6. **Closing (2:45-3:00)**
   - Show package ID
   - "Live on IOTA testnet, ready for mainnet"
   - "Built for Moveathon Europe 2024"

## Submission Information

**Project Name:** TangleArb
**Tagline:** Feeless Arbitrage Vault on IOTA MoveVM
**Network:** IOTA Testnet
**Package ID:** (Will be available after publish)
**Demo Video:** (To be recorded)
**GitHub:** (If applicable)

## Private Key (Testnet)

```
iotaprivkey1qz0l7rtlw07r5a5cr8d3emham88yznnvmd6udpkxhfnf7nqkna09cqhqen9
```

This key already has testnet tokens.

## Quick Start Commands

```bash
# 1. Import key and verify
iota keytool import <private_key> ed25519 --alias tanglearb_wallet

# 2. Build Move package
iota move build

# 3. Publish to testnet
iota move publish --network testnet

# 4. Run bot
./tanglearb-bot/target/release/tanglearb-bot \
  --package-id <PACKAGE_ID> \
  --vault-object-id <VAULT_OBJECT_ID> \
  --private-key <PRIVATE_KEY>

# 5. Run frontend
pnpm dev
```

## Files Ready for Submission

- ✅ Move smart contracts (sources/)
- ✅ Unit tests (tests/)
- ✅ Rust bot (compiled)
- ✅ Frontend (Next.js app)
- ✅ Documentation
- ✅ Deployment scripts
- ⏳ Package ID (after publish)
- ⏳ Demo video (to record)

## Next Steps for Submission

1. ✅ Complete IOTA CLI installation
2. ✅ Publish Move package to testnet
3. ✅ Get Package ID
4. ✅ Initialize vault
5. ✅ Record demo video
6. ✅ Submit to Moveathon Europe

