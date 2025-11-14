# TangleArb Quick Start Guide

## Package Overview

TangleArb is a complete IOTA MoveVM package for automated arbitrage trading.

## Quick Commands

### Build
```bash
iota move build
```

### Test
```bash
iota move test
```

### Publish to Testnet
```bash
iota move publish --network testnet
```

### Publish to Mainnet
```bash
iota move publish --network mainnet
```

## Module Quick Reference

### Vault Module
- Initialize: `vault::initialize_vault(owner)`
- Deposit: `vault::deposit(owner, vault_obj, coin)`
- Withdraw: `vault::withdraw(owner, vault_obj, amount)`
- Get Balance: `vault::get_balance(vault_obj)`
- Get Profits: `vault::get_total_profits(vault_obj)`

### Arbitrage Executor
- Execute Dummy Arb: `arb_executor::execute_dummy_arb(vault_obj, amount, profit_percent)`
- Calculate Profit: `arb_executor::calculate_profit(amount, source_price, target_price)`
- Execute Swap: `arb_executor::execute_swap(dex_id, coin_in, min_amount_out)`

### Flash Loan
- Initialize Pool: `flash_loan::initialize_pool(admin)`
- Add Liquidity: `flash_loan::add_liquidity(pool_obj, coin)`
- Borrow: `flash_loan::borrow(pool_obj, borrower, amount)`
- Repay: `flash_loan::repay(pool_obj, repayment_coin)`

### Strategy Registry
- Initialize: `strategy_registry::initialize_registry(owner)`
- Register: `strategy_registry::register_strategy(...)`
- Update: `strategy_registry::update_strategy(...)`
- Enable/Disable: `strategy_registry::set_strategy_active(...)`

## Architecture Notes

- **Friend Functions**: `arb_executor` and `flash_loan` are friends of `vault` module
- **Object Model**: All user data stored as IOTA Move objects
- **Shareable Vaults**: Vault objects can be shared with off-chain bots
- **Zero-Fee Flash Loans**: Same-bundle borrow/repay mechanism

## Error Codes

### Vault Module
- `E_VAULT_NOT_FOUND = 1`
- `E_INSUFFICIENT_BALANCE = 2`
- `E_INVALID_AMOUNT = 3`
- `E_VAULT_ALREADY_EXISTS = 4`
- `E_NOT_VAULT_OWNER = 5`

### Arbitrage Executor
- `E_INVALID_ARB_PATH = 1`
- `E_INSUFFICIENT_PROFIT = 2`
- `E_ARB_FAILED = 3`
- `E_INVALID_AMOUNT = 4`

### Flash Loan
- `E_INVALID_AMOUNT = 1`
- `E_INSUFFICIENT_LIQUIDITY = 2`
- `E_LOAN_NOT_REPAID = 3`
- `E_LOAN_ALREADY_ACTIVE = 4`
- `E_INVALID_REPAYMENT = 5`

### Strategy Registry
- `E_STRATEGY_NOT_FOUND = 1`
- `E_STRATEGY_ALREADY_EXISTS = 2`
- `E_INVALID_PARAMETERS = 3`
- `E_NOT_STRATEGY_OWNER = 4`
- `E_STRATEGY_DISABLED = 5`

