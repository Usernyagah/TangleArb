# TangleArb – IOTA Arbitrage Vault System

## Project Overview
TangleArb is a fully integrated, open-source arbitrage trading platform built on IOTA MoveVM. It combines:
- **Move smart contracts** (vaults, strategies, flash loans)
- **A Rust arbitrage bot** (automatic trade executor)
- **A Next.js/React frontend** (live on-chain stats/user wallet connection)

**Built for Moveathon Europe, providing feeless, gasless, scalable profit automation.**

---

## System Requirements / Prerequisites
- Linux/macOS/WSL2 (recommended for Move and Rust builds)
- Rust & Cargo (1.70+)
- Node.js (18+) & pnpm/npm
- IOTA CLI (built from https://github.com/iotaledger/iota.git, branch: testnet)
- Basic terminal use

If you need detailed install guidance, see `DEPLOY_TANGLEARB_IN_15_MINUTES.md`.

---

## Deployed Contracts (IOTA Testnet)
**Current Move Package ID:**
```
0x944d5537ee25d65f1fcdf2ede684b43e7704329af5e1e7d3a84ff5bbd57305ea
```
- Modules live: `arb_executor`, `flash_loan`, `strategy_registry`, `vault`
> **Note:** If you re-publish, the Package ID in IOTA testnet changes. This README reflects the last successful deployment.

---

## Step-by-Step Quick Start

### 1. Install Core CLI Dependencies
```bash
# (1) Install Rust if needed
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# (2) Install IOTA CLI (Move-enabled, on testnet branch)
cargo install --locked --git https://github.com/iotaledger/iota.git --branch testnet iota

iota --version
```

### 2. Set Up Wallet & Get Testnet Funds
```bash
# Create wallet (if not already)
iota wallet create
# Save your mnemonic phrase! Required for bot and frontend.
# Visit https://faucet.testnet.iota.org and request tokens for your wallet address.
```

### 3. Build & Publish Move Contracts
```bash
iota move build
iota move publish --network testnet
# Copy the displayed Package ID (see above for an example)
```

### 4. Initialize Your Vault (one-time per user)
```bash
iota move call \
  --network testnet \
  --package-id <YOUR_PACKAGE_ID> \
  --module vault \
  --function initialize_vault \
  --signer <YOUR_WALLET_ADDRESS>
# Copy your Vault Object ID from the output
```

### 5. Run the Arbitrage Bot
```bash
cd tanglearb-bot
cargo build --release
./target/release/tanglearb-bot \
  --package-id <YOUR_PACKAGE_ID> \
  --vault-object-id <YOUR_VAULT_OBJECT_ID>
# The bot finds/test/arbs opportunities and submits txs to the IOTA chain
```

### 6. Launch the Next.js Frontend
```bash
pnpm install
pnpm dev
# Open http://localhost:3000
# Connect wallet (use mnemonic from Step 2)
# View live on-chain vault stats/profits from your arbitrage bot
```

---

## Core Architecture
### Move Modules
- **vault.move** — User deposit/withdraw, capital accounting
- **arb_executor.move** — Arbitrage routing, main execution
- **flash_loan.move** — Flash loan provider integration
- **strategy_registry.move** — Manage arbitrage strategies

### Rust Bot
- Polls chains for opportunities using IOTA SDK
- Submits on-chain transactions with wallet/mnemonic
- Works off-chain, but all profits/on-chain changes are reflected via the contracts

### Next.js Frontend
- Wallet connect (mnemonic for demo), balance, vault stats, live updates
- No backend required; interacts direct to IOTA testnet

---

## Integration & Workflow
- Publish Move contracts
- Create vault (each user)
- Run bot for your vault; profits accrue on-chain
- Frontend auto-syncs stats from IOTA testnet (live vault balance, profits, trade activity)

---

## Troubleshooting
- 
  - **Wallet/CLI not found:** Ensure Rust, Node.js, and IOTA CLI (with Move support) are properly installed and in PATH
  - **Vault/Package ID ambiguity:** Re-initialize if you publish a new package
  - **Bot build fails:** Ensure system deps—see errors for missing libraries (e.g. clang, protobuf, libudev)
  - **Frontend blank/disconnected:** Run on supported Node.js LTS, clear pnpm cache if needed
  - See `DEPLOY_TANGLEARB_IN_15_MINUTES.md` for specifics and fixes

---

## Moveathon Europe & Demo
- **Demo video script:** In `DEPLOY_TANGLEARB_IN_15_MINUTES.md`
- **Submission checklist:** Also included there (published Package ID, demo link, GitHub, features)
- **Key features:**
  - Feeless arbitrage (0 gas, infinite tx)
  - Shareable vaults, off-chain bot, flash loan support
  - Live stats, modern UI, open hackathon

---

## Contribution & Security
- **Move code is for demo/hackathon.**
- No mainnet security or audit warranties—review and harden before production.
- PRs, suggestions, and bug reports are welcome!

---

## Credits
Built for Moveathon Europe. Powered by IOTA MoveVM, Rust, Next.js, TypeScript.

*For full advanced deployment flow, see `DEPLOY_TANGLEARB_IN_15_MINUTES.md`.*

