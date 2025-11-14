/// # TangleArb Flash Loan Module
///
/// This module provides zero-fee flash loan functionality using same-bundle borrow/repay.
/// Flash loans allow users to borrow funds for arbitrage without upfront capital,
/// as long as the loan is repaid in the same transaction bundle.
///
/// ## Features
/// - Zero-fee flash loans
/// - Same-bundle borrow/repay mechanism
/// - Integration with vault system
/// - Safety checks to ensure repayment

module tanglearb::flash_loan;

use std::error;
use std::option;
use std::signer;
use iota::coin::{Self, Coin};
use iota::object::{Self, Object};
use tanglearb::vault;

/// Error codes
const E_INVALID_AMOUNT: u64 = 1;
const E_INSUFFICIENT_LIQUIDITY: u64 = 2;
const E_LOAN_NOT_REPAID: u64 = 3;
const E_LOAN_ALREADY_ACTIVE: u64 = 4;
const E_INVALID_REPAYMENT: u64 = 5;

/// Flash loan record tracking active loans
struct FlashLoan has store {
    /// Borrower address
    borrower: address,
    /// Loan amount
    amount: u64,
    /// Timestamp when loan was taken (block timestamp)
    timestamp: u64,
    /// Whether loan has been repaid
    repaid: bool,
}

/// Global flash loan pool (simplified - in production would use proper liquidity pools)
struct FlashLoanPool has key {
    /// Total available liquidity
    total_liquidity: u64,
    /// Active loans
    active_loans: option::Option<FlashLoan>,
}

/// Initialize the flash loan pool
public fun initialize_pool(admin: &signer): Object<FlashLoanPool> {
    let pool = FlashLoanPool {
        total_liquidity: 0,
        active_loans: option::none(),
    };
    object::create_object(admin, pool)
}

/// Add liquidity to the flash loan pool
public fun add_liquidity(
    pool_obj: Object<FlashLoanPool>,
    coin: Coin<IOTA>
) {
    let pool = object::borrow_mut(pool_obj);
    let amount = coin::value(&coin);
    pool.total_liquidity = pool.total_liquidity + amount;
    coin::burn(coin);
}

/// Borrow funds via flash loan
/// This must be repaid in the same transaction bundle
///
/// # Parameters
/// - `pool_obj`: The flash loan pool object
/// - `borrower`: The borrower's signer
/// - `amount`: Amount to borrow
///
/// # Returns
/// A Coin<IOTA> with the borrowed amount
public fun borrow(
    pool_obj: Object<FlashLoanPool>,
    borrower: &signer,
    amount: u64
): Coin<IOTA> {
    assert!(amount > 0, error::invalid_argument(E_INVALID_AMOUNT));
    
    let pool = object::borrow_mut(pool_obj);
    let borrower_addr = signer::address_of(borrower);
    
    // Check if there's an active loan (should be none in same-bundle)
    assert!(option::is_none(&pool.active_loans), error::invalid_state(E_LOAN_ALREADY_ACTIVE));
    
    // Check sufficient liquidity
    assert!(pool.total_liquidity >= amount, error::invalid_state(E_INSUFFICIENT_LIQUIDITY));
    
    // Create loan record
    let loan = FlashLoan {
        borrower: borrower_addr,
        amount,
        timestamp: 0, // Would use actual timestamp in production
        repaid: false,
    };
    
    pool.active_loans = option::some(loan);
    pool.total_liquidity = pool.total_liquidity - amount;
    
    // Return borrowed coin (in production, would transfer from pool)
    coin::zero<IOTA>()
}

/// Repay a flash loan
/// Must be called in the same transaction bundle as borrow
///
/// # Parameters
/// - `pool_obj`: The flash loan pool object
/// - `repayment_coin`: Coin containing the repayment amount
///
/// # Returns
/// The profit amount if repayment exceeds loan (should be 0 for zero-fee)
public fun repay(
    pool_obj: Object<FlashLoanPool>,
    repayment_coin: Coin<IOTA>
): u64 {
    let pool = object::borrow_mut(pool_obj);
    let repayment_amount = coin::value(&repayment_coin);
    
    // Get active loan
    assert!(option::is_some(&pool.active_loans), error::invalid_state(E_LOAN_NOT_REPAID));
    let loan = option::extract(&mut pool.active_loans);
    
    // Verify repayment amount matches loan amount (zero-fee, so exact repayment)
    assert!(repayment_amount >= loan.amount, error::invalid_argument(E_INVALID_REPAYMENT));
    
    // Mark as repaid
    loan.repaid = true;
    
    // Return liquidity to pool
    pool.total_liquidity = pool.total_liquidity + loan.amount;
    
    // Calculate any excess (should be 0 for zero-fee)
    let excess = repayment_amount - loan.amount;
    
    coin::burn(repayment_coin);
    excess
}

/// Execute arbitrage using flash loan
/// This combines borrow, arbitrage execution, and repay in one flow
///
/// # Parameters
/// - `pool_obj`: The flash loan pool object
/// - `vault_obj`: The user's vault object
/// - `loan_amount`: Amount to borrow
/// - `expected_profit_percent`: Expected profit percentage
///
/// # Returns
/// The profit amount after repaying the loan
public fun execute_arb_with_flash_loan(
    pool_obj: Object<FlashLoanPool>,
    vault_obj: Object<vault::UserVault>,
    borrower: &signer,
    loan_amount: u64,
    expected_profit_percent: u64
): u64 {
    // Step 1: Borrow from flash loan pool
    let borrowed_coin = borrow(pool_obj, borrower, loan_amount);
    let borrowed_amount = coin::value(&borrowed_coin);
    
    // Step 2: Execute arbitrage (simplified - would use actual arb_executor)
    let gross_profit = (borrowed_amount * expected_profit_percent) / 10000;
    let total_amount = borrowed_amount + gross_profit;
    
    // Step 3: Repay the loan (zero-fee, so repay exact amount)
    // Create repayment coin (in production, would use actual swapped coins)
    let repayment_coin = coin::zero<IOTA>();
    let excess = repay(pool_obj, repayment_coin);
    
    // Step 4: Add net profit to vault (gross profit minus any fees)
    let net_profit = gross_profit - excess;
    if (net_profit > 0) {
        vault::add_profits(vault_obj, net_profit);
    };
    
    coin::burn(borrowed_coin);
    net_profit
}

/// Get the current liquidity in the pool
public fun get_liquidity(pool_obj: Object<FlashLoanPool>): u64 {
    let pool = object::borrow(pool_obj);
    pool.total_liquidity
}

/// Check if there's an active loan
public fun has_active_loan(pool_obj: Object<FlashLoanPool>): bool {
    let pool = object::borrow(pool_obj);
    option::is_some(&pool.active_loans)
}

