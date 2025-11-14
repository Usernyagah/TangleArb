# TangleArb - IOTA MoveVM Arbitrage Package

A complete, production-ready IOTA MoveVM package for automated arbitrage trading on the IOTA network. Built for the Moveathon Europe hackathon.

## Overview

TangleArb enables users to:
- Manage their arbitrage capital in secure vaults
- Execute arbitrage opportunities automatically
- Use zero-fee flash loans for capital-efficient trading
- Register and manage custom arbitrage strategies

## Package Structure

```
tanglearb/
├── Move.toml              # Package configuration
├── sources/               # Move source modules
│   ├── vault.move         # User vault management
│   ├── arb_executor.move  # Arbitrage execution
│   ├── flash_loan.move    # Flash loan functionality
│   └── strategy_registry.move # Strategy management
└── tests/                 # Unit tests
    ├── vault_test.move
    ├── arb_executor_test.move
    ├── flash_loan_test.move
    └── strategy_registry_test.move
```

## Modules

### 1. Vault Module (`vault.move`)

Manages user vaults for storing capital and tracking profits.

**Key Functions:**
- `initialize_vault(owner: &signer): Object<UserVault>` - Create a new vault
- `deposit(owner: &signer, vault_obj: Object<UserVault>, coin: Coin<IOTA>): u64` - Deposit IOTA
- `withdraw(owner: &signer, vault_obj: Object<UserVault>, amount: u64): Coin<IOTA>` - Withdraw IOTA
- `get_balance(vault_obj: Object<UserVault>): u64` - Get current balance
- `get_total_profits(vault_obj: Object<UserVault>): u64` - Get total profits

**Features:**
- Shareable vault objects for off-chain bot access
- Automatic profit tracking
- Deposit/withdrawal history

### 2. Arbitrage Executor Module (`arb_executor.move`)

Executes arbitrage opportunities between DEXes.

**Key Functions:**
- `execute_dummy_arb(vault_obj, amount, profit_percent): u64` - Demo arbitrage execution
- `execute_arb_with_path(vault_obj, path_id, amount): u64` - Execute using registered path
- `execute_arbitrage_cycle(vault_obj, source_dex, target_dex, amount): u64` - Full arbitrage cycle
- `calculate_profit(amount, source_price, target_price): u64` - Calculate potential profit
- `execute_swap(dex_id, coin_in, min_amount_out): Option<Coin<IOTA>>` - DEX swap placeholder

**Features:**
- Friend functions for off-chain bot access
- Automatic profit distribution to vaults
- Placeholder for real DEX integrations

### 3. Flash Loan Module (`flash_loan.move`)

Provides zero-fee flash loans using same-bundle borrow/repay.

**Key Functions:**
- `initialize_pool(admin: &signer): Object<FlashLoanPool>` - Create flash loan pool
- `add_liquidity(pool_obj, coin: Coin<IOTA>)` - Add liquidity to pool
- `borrow(pool_obj, borrower: &signer, amount: u64): Coin<IOTA>` - Borrow funds
- `repay(pool_obj, repayment_coin: Coin<IOTA>): u64` - Repay loan
- `execute_arb_with_flash_loan(...)` - Complete flash loan arbitrage flow

**Features:**
- Zero-fee flash loans
- Same-bundle borrow/repay mechanism
- Integration with vault system

### 4. Strategy Registry Module (`strategy_registry.move`)

Allows users to register and manage custom arbitrage strategies.

**Key Functions:**
- `initialize_registry(owner: &signer): Object<StrategyRegistry>` - Create registry
- `register_strategy(...): u64` - Register new strategy
- `update_strategy(...)` - Update existing strategy
- `set_strategy_active(...)` - Enable/disable strategy
- `get_user_strategies(...): vector<u64>` - Get user's strategies

**Features:**
- Custom arbitrage path configuration
- Profit threshold management
- Strategy enable/disable controls

## Usage

### Building the Package

```bash
iota move build
```

### Running Tests

```bash
iota move test
```

### Publishing to IOTA Testnet

```bash
iota move publish --network testnet
```

### Publishing to IOTA Mainnet

```bash
iota move publish --network mainnet
```

## Example Workflow

1. **Initialize Vault:**
   ```move
   let vault = vault::initialize_vault(user);
   ```

2. **Deposit Capital:**
   ```move
   vault::deposit(user, vault_obj, coin);
   ```

3. **Register Strategy:**
   ```move
   let strategy_id = strategy_registry::register_strategy(
       registry_obj,
       user,
       source_dex,
       target_dex,
       min_profit_threshold,
       max_trade_amount,
       name
   );
   ```

4. **Execute Arbitrage:**
   ```move
   let profit = arb_executor::execute_dummy_arb(vault_obj, amount, profit_percent);
   ```

## Security Features

- **Friend Functions:** Only authorized modules can call sensitive functions
- **Ownership Checks:** All operations verify vault/strategy ownership
- **Input Validation:** All functions validate inputs and amounts
- **Error Handling:** Comprehensive error codes for all failure cases

## Network Support

- ✅ IOTA Testnet
- ✅ IOTA Mainnet

## Dependencies

- MoveStdlib (latest)
- IOTA Move Framework (latest)

## License

This package is created for the Moveathon Europe hackathon.

## Contributing

This is a hackathon project. For production use, additional security audits and testing are recommended.

