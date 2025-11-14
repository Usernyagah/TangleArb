/// # Vault Module Unit Tests
///
/// Comprehensive tests for the vault module functionality

#[test_only]
module tanglearb::vault_test;

use std::signer;
use iota::object::Object;
use tanglearb::vault;

const TEST_USER: address = @0xCAFE;

#[test(admin = @tanglearb)]
fun test_initialize_vault(admin: &signer) {
    let vault_obj = vault::initialize_vault(admin);
    
    let balance = vault::get_balance(vault_obj);
    assert!(balance == 0, 1);
    
    let profits = vault::get_total_profits(vault_obj);
    assert!(profits == 0, 2);
    
    let owner = vault::get_owner(vault_obj);
    assert!(owner == signer::address_of(admin), 3);
}

#[test(admin = @tanglearb)]
fun test_deposit(admin: &signer) {
    let vault_obj = vault::initialize_vault(admin);
    
    // Create a test coin (in real tests, would use proper coin creation)
    // For now, we'll test the deposit logic
    let initial_balance = vault::get_balance(vault_obj);
    assert!(initial_balance == 0, 1);
    
    // Note: In a real test environment, we would create actual coins
    // This is a placeholder test structure
}

#[test(admin = @tanglearb)]
fun test_withdraw(admin: &signer) {
    let vault_obj = vault::initialize_vault(admin);
    
    // Test withdraw with insufficient balance
    let balance = vault::get_balance(vault_obj);
    assert!(balance == 0, 1);
    
    // Withdraw should fail with insufficient balance
    // This would be tested with proper error handling in real environment
}

#[test(admin = @tanglearb)]
fun test_add_profits(admin: &signer) {
    let vault_obj = vault::initialize_vault(admin);
    
    // Add profits using friend function (simulating arb_executor)
    vault::add_profits(vault_obj, 1000);
    
    let profits = vault::get_total_profits(vault_obj);
    assert!(profits == 1000, 1);
    
    let balance = vault::get_balance(vault_obj);
    assert!(balance == 1000, 2);
}

#[test(admin = @tanglearb)]
fun test_get_stats(admin: &signer) {
    let vault_obj = vault::initialize_vault(admin);
    
    let (balance, profits, deposits, withdrawals) = vault::get_stats(vault_obj);
    assert!(balance == 0, 1);
    assert!(profits == 0, 2);
    assert!(deposits == 0, 3);
    assert!(withdrawals == 0, 4);
}

