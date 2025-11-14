/// # Strategy Registry Module Unit Tests
///
/// Comprehensive tests for strategy registration and management

#[test_only]
module tanglearb::strategy_registry_test;

use std::signer;
use std::vector;
use iota::object::Object;
use tanglearb::strategy_registry;

const TEST_USER: address = @0xCAFE;

#[test(admin = @tanglearb)]
fun test_initialize_registry(admin: &signer) {
    let registry_obj = strategy_registry::initialize_registry(admin);
    
    let count = strategy_registry::get_strategy_count(registry_obj);
    assert!(count == 0, 1);
}

#[test(admin = @tanglearb)]
fun test_register_strategy(admin: &signer) {
    let registry_obj = strategy_registry::initialize_registry(admin);
    
    let name = b"Test Strategy";
    let strategy_id = strategy_registry::register_strategy(
        registry_obj,
        admin,
        1, // source_dex
        2, // target_dex
        1000, // min_profit_threshold
        50000, // max_trade_amount
        name
    );
    
    assert!(strategy_id == 1, 1);
    
    let count = strategy_registry::get_strategy_count(registry_obj);
    assert!(count == 1, 2);
}

#[test(admin = @tanglearb)]
fun test_register_multiple_strategies(admin: &signer) {
    let registry_obj = strategy_registry::initialize_registry(admin);
    
    let name1 = b"Strategy 1";
    let id1 = strategy_registry::register_strategy(
        registry_obj,
        admin,
        1,
        2,
        1000,
        50000,
        name1
    );
    
    let name2 = b"Strategy 2";
    let id2 = strategy_registry::register_strategy(
        registry_obj,
        admin,
        2,
        3,
        2000,
        100000,
        name2
    );
    
    assert!(id1 == 1, 1);
    assert!(id2 == 2, 2);
    
    let count = strategy_registry::get_strategy_count(registry_obj);
    assert!(count == 2, 3);
}

#[test(admin = @tanglearb)]
fun test_get_user_strategies(admin: &signer) {
    let registry_obj = strategy_registry::initialize_registry(admin);
    let admin_addr = signer::address_of(admin);
    
    let name = b"Test Strategy";
    strategy_registry::register_strategy(
        registry_obj,
        admin,
        1,
        2,
        1000,
        50000,
        name
    );
    
    let strategies = strategy_registry::get_user_strategies(registry_obj, admin_addr);
    let count = vector::length(&strategies);
    assert!(count == 1, 1);
}

#[test(admin = @tanglearb)]
fun test_update_strategy(admin: &signer) {
    let registry_obj = strategy_registry::initialize_registry(admin);
    
    let name = b"Test Strategy";
    let strategy_id = strategy_registry::register_strategy(
        registry_obj,
        admin,
        1,
        2,
        1000,
        50000,
        name
    );
    
    // Update strategy
    strategy_registry::update_strategy(
        registry_obj,
        admin,
        strategy_id,
        2000, // new min_profit_threshold
        100000 // new max_trade_amount
    );
    
    // Verify update (would need getter function in real implementation)
    let count = strategy_registry::get_strategy_count(registry_obj);
    assert!(count == 1, 1);
}

#[test(admin = @tanglearb)]
fun test_set_strategy_active(admin: &signer) {
    let registry_obj = strategy_registry::initialize_registry(admin);
    
    let name = b"Test Strategy";
    let strategy_id = strategy_registry::register_strategy(
        registry_obj,
        admin,
        1,
        2,
        1000,
        50000,
        name
    );
    
    // Disable strategy
    strategy_registry::set_strategy_active(registry_obj, admin, strategy_id, false);
    
    // Re-enable strategy
    strategy_registry::set_strategy_active(registry_obj, admin, strategy_id, true);
    
    let count = strategy_registry::get_strategy_count(registry_obj);
    assert!(count == 1, 1);
}

#[test(admin = @tanglearb)]
#[expected_failure(abort_code = 65539)] // E_INVALID_PARAMETERS
fun test_register_strategy_same_dex(admin: &signer) {
    let registry_obj = strategy_registry::initialize_registry(admin);
    
    let name = b"Invalid Strategy";
    // Should fail - source and target DEX are the same
    strategy_registry::register_strategy(
        registry_obj,
        admin,
        1,
        1, // Same as source
        1000,
        50000,
        name
    );
}

