/// # TangleArb Vault Module
///
/// This module provides a user vault system for managing deposits, withdrawals, and profit tracking.
/// Each user has their own vault that is shareable and owned by their address.
///
/// ## Features
/// - Deposit IOTA tokens into vault
/// - Withdraw IOTA tokens from vault
/// - Track profits from arbitrage operations
/// - Shareable vault object for off-chain bot access

module tanglearb::vault;

use std::signer;
use std::error;
use std::option;
use iota::coin::{Self, Coin};
use iota::object::{Self, Object};

friend tanglearb::arb_executor;
friend tanglearb::flash_loan;

/// Error codes
const E_VAULT_NOT_FOUND: u64 = 1;
const E_INSUFFICIENT_BALANCE: u64 = 2;
const E_INVALID_AMOUNT: u64 = 3;
const E_VAULT_ALREADY_EXISTS: u64 = 4;
const E_NOT_VAULT_OWNER: u64 = 5;

/// UserVault object containing user's balance and profit information
struct UserVault has key, store {
    /// Owner address of this vault
    owner: address,
    /// Current balance in the vault
    balance: u64,
    /// Total profits earned from arbitrage
    total_profits: u64,
    /// Total deposits made
    total_deposits: u64,
    /// Total withdrawals made
    total_withdrawals: u64,
}

/// Initialize a new vault for the caller
/// Returns the Object<UserVault> that can be shared with off-chain bots
public fun initialize_vault(owner: &signer): Object<UserVault> {
    let owner_addr = signer::address_of(owner);
    
    // Create the vault object
    let vault = UserVault {
        owner: owner_addr,
        balance: 0,
        total_profits: 0,
        total_deposits: 0,
        total_withdrawals: 0,
    };
    
    // Create and transfer the object to the owner
    object::create_object(owner, vault)
}

/// Deposit IOTA tokens into the user's vault
/// The vault object must be owned by the caller
public fun deposit(
    owner: &signer,
    vault_obj: Object<UserVault>,
    coin: Coin<IOTA>
): u64 {
    let owner_addr = signer::address_of(owner);
    let vault = object::borrow_mut(vault_obj);
    
    assert!(vault.owner == owner_addr, error::permission_denied(E_NOT_VAULT_OWNER));
    
    let amount = coin::value(&coin);
    assert!(amount > 0, error::invalid_argument(E_INVALID_AMOUNT));
    
    // Add to balance
    vault.balance = vault.balance + amount;
    vault.total_deposits = vault.total_deposits + amount;
    
    // Transfer coin to vault (in a real implementation, this would be stored in the vault object)
    // For now, we'll destroy it as a placeholder
    coin::burn(coin);
    
    amount
}

/// Withdraw IOTA tokens from the user's vault
/// Returns a Coin<IOTA> with the requested amount
public fun withdraw(
    owner: &signer,
    vault_obj: Object<UserVault>,
    amount: u64
): Coin<IOTA> {
    let owner_addr = signer::address_of(owner);
    let vault = object::borrow_mut(vault_obj);
    
    assert!(vault.owner == owner_addr, error::permission_denied(E_NOT_VAULT_OWNER));
    assert!(amount > 0, error::invalid_argument(E_INVALID_AMOUNT));
    assert!(vault.balance >= amount, error::invalid_state(E_INSUFFICIENT_BALANCE));
    
    // Deduct from balance
    vault.balance = vault.balance - amount;
    vault.total_withdrawals = vault.total_withdrawals + amount;
    
    // In a real implementation, we would withdraw from stored coins
    // For now, create a new coin as placeholder (this would need proper coin management)
    coin::zero<IOTA>()
}

/// Add profits to the vault (called by arb_executor after successful arbitrage)
/// This is a friend function that can only be called by authorized modules
public(friend) fun add_profits(
    vault_obj: Object<UserVault>,
    amount: u64
) {
    let vault = object::borrow_mut(vault_obj);
    vault.total_profits = vault.total_profits + amount;
    vault.balance = vault.balance + amount;
}

/// Deduct from vault balance (used by flash loans and arbitrage operations)
/// This is a friend function that can only be called by authorized modules
public(friend) fun deduct_balance(
    vault_obj: Object<UserVault>,
    amount: u64
) {
    let vault = object::borrow_mut(vault_obj);
    assert!(vault.balance >= amount, error::invalid_state(E_INSUFFICIENT_BALANCE));
    vault.balance = vault.balance - amount;
}

/// Get the current balance of the vault
public fun get_balance(vault_obj: Object<UserVault>): u64 {
    let vault = object::borrow(vault_obj);
    vault.balance
}

/// Get the total profits earned
public fun get_total_profits(vault_obj: Object<UserVault>): u64 {
    let vault = object::borrow(vault_obj);
    vault.total_profits
}

/// Get the owner address of the vault
public fun get_owner(vault_obj: Object<UserVault>): address {
    let vault = object::borrow(vault_obj);
    vault.owner
}

/// Get vault statistics
public fun get_stats(vault_obj: Object<UserVault>): (u64, u64, u64, u64) {
    let vault = object::borrow(vault_obj);
    (vault.balance, vault.total_profits, vault.total_deposits, vault.total_withdrawals)
}

