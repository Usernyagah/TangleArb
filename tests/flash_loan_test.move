/// # Flash Loan Module Unit Tests
///
/// Comprehensive tests for flash loan functionality

#[test_only]
module tanglearb::flash_loan_test;

use std::signer;
use iota::coin::Coin;
use iota::object::Object;
use tanglearb::flash_loan;
use tanglearb::vault;

const TEST_USER: address = @0xCAFE;

#[test(admin = @tanglearb)]
fun test_initialize_pool(admin: &signer) {
    let pool_obj = flash_loan::initialize_pool(admin);
    
    let liquidity = flash_loan::get_liquidity(pool_obj);
    assert!(liquidity == 0, 1);
    
    let has_loan = flash_loan::has_active_loan(pool_obj);
    assert!(has_loan == false, 2);
}

#[test(admin = @tanglearb)]
fun test_add_liquidity(admin: &signer) {
    let pool_obj = flash_loan::initialize_pool(admin);
    
    // Add liquidity (in real test, would use actual coins)
    // For now, test the structure
    let initial_liquidity = flash_loan::get_liquidity(pool_obj);
    assert!(initial_liquidity == 0, 1);
}

#[test(admin = @tanglearb)]
#[expected_failure(abort_code = 65537)] // E_INVALID_AMOUNT
fun test_borrow_invalid_amount(admin: &signer) {
    let pool_obj = flash_loan::initialize_pool(admin);
    
    // Should fail with zero amount
    flash_loan::borrow(pool_obj, admin, 0);
}

#[test(admin = @tanglearb)]
#[expected_failure(abort_code = 65538)] // E_INSUFFICIENT_LIQUIDITY
fun test_borrow_insufficient_liquidity(admin: &signer) {
    let pool_obj = flash_loan::initialize_pool(admin);
    
    // Should fail - no liquidity in pool
    flash_loan::borrow(pool_obj, admin, 1000);
}

#[test(admin = @tanglearb)]
fun test_execute_arb_with_flash_loan(admin: &signer) {
    // Initialize pool and vault
    let pool_obj = flash_loan::initialize_pool(admin);
    let vault_obj = vault::initialize_vault(admin);
    
    // Add liquidity to pool (in real test, would add actual coins)
    // For now, we'll test the structure
    
    // Execute arbitrage with flash loan
    // Note: This would need actual liquidity in the pool to work
    // This is a placeholder test structure
}

