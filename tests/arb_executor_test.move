/// # Arbitrage Executor Module Unit Tests
///
/// Comprehensive tests for arbitrage execution functionality

#[test_only]
module tanglearb::arb_executor_test;

use std::signer;
use iota::object::Object;
use tanglearb::vault;
use tanglearb::arb_executor;

const TEST_USER: address = @0xCAFE;

#[test(admin = @tanglearb)]
fun test_execute_dummy_arb(admin: &signer) {
    // Initialize vault
    let vault_obj = vault::initialize_vault(admin);
    
    // Add initial balance to vault (simulate deposit)
    vault::add_profits(vault_obj, 10000);
    
    let initial_balance = vault::get_balance(vault_obj);
    assert!(initial_balance == 10000, 1);
    
    // Execute dummy arbitrage with 2% profit
    let profit = arb_executor::execute_dummy_arb(vault_obj, 5000, 200);
    
    // Profit should be 5000 * 2% = 100
    assert!(profit == 100, 2);
    
    // Check final balance: 10000 - 5000 (used) + 5000 (returned) + 100 (profit) = 10100
    let final_balance = vault::get_balance(vault_obj);
    assert!(final_balance == 10100, 3);
    
    // Check profits
    let total_profits = vault::get_total_profits(vault_obj);
    assert!(total_profits == 100, 4);
}

#[test(admin = @tanglearb)]
fun test_calculate_profit(admin: &signer) {
    // Test profit calculation with favorable price difference
    let amount = 10000;
    let source_price = 100;
    let target_price = 102; // 2% higher
    
    let profit = arb_executor::calculate_profit(amount, source_price, target_price);
    
    // Expected: (10000 * 102) / 100 - 10000 = 200
    assert!(profit == 200, 1);
    
    // Test with no profit opportunity
    let profit2 = arb_executor::calculate_profit(amount, 100, 100);
    assert!(profit2 == 0, 2);
    
    // Test with negative opportunity (should return 0)
    let profit3 = arb_executor::calculate_profit(amount, 102, 100);
    assert!(profit3 == 0, 3);
}

#[test(admin = @tanglearb)]
#[expected_failure(abort_code = 65537)] // E_INVALID_AMOUNT
fun test_execute_dummy_arb_invalid_amount(admin: &signer) {
    let vault_obj = vault::initialize_vault(admin);
    
    // Should fail with zero amount
    arb_executor::execute_dummy_arb(vault_obj, 0, 200);
}

#[test(admin = @tanglearb)]
#[expected_failure(abort_code = 65538)] // E_INSUFFICIENT_PROFIT
fun test_execute_dummy_arb_insufficient_profit(admin: &signer) {
    let vault_obj = vault::initialize_vault(admin);
    vault::add_profits(vault_obj, 10000);
    
    // Should fail with zero profit percent
    arb_executor::execute_dummy_arb(vault_obj, 5000, 0);
}

