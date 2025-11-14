/// # TangleArb Strategy Registry Module
///
/// This module allows users to register custom arbitrage paths and strategies.
/// Registered strategies can be executed by off-chain bots automatically.
///
/// ## Features
/// - Register custom arbitrage paths
/// - Store strategy parameters (DEX pairs, profit thresholds, etc.)
/// - Query registered strategies
/// - Enable/disable strategies

module tanglearb::strategy_registry;

use std::error;
use std::signer;
use std::option;
use iota::object::{Self, Object};
use std::vector;

friend tanglearb::arb_executor;

/// Error codes
const E_STRATEGY_NOT_FOUND: u64 = 1;
const E_STRATEGY_ALREADY_EXISTS: u64 = 2;
const E_INVALID_PARAMETERS: u64 = 3;
const E_NOT_STRATEGY_OWNER: u64 = 4;
const E_STRATEGY_DISABLED: u64 = 5;

/// Arbitrage strategy configuration
struct ArbStrategy has store {
    /// Strategy owner address
    owner: address,
    /// Unique strategy ID
    strategy_id: u64,
    /// Source DEX identifier
    source_dex: u64,
    /// Target DEX identifier
    target_dex: u64,
    /// Minimum profit threshold (in microIOTA)
    min_profit_threshold: u64,
    /// Maximum amount per trade
    max_trade_amount: u64,
    /// Whether strategy is active
    is_active: bool,
    /// Strategy name/description
    name: vector<u8>,
}

/// Registry containing all user strategies
struct StrategyRegistry has key {
    /// Map of strategy ID to strategy object
    strategies: vector<ArbStrategy>,
    /// Next strategy ID counter
    next_strategy_id: u64,
}

/// Initialize a strategy registry for a user
public fun initialize_registry(owner: &signer): Object<StrategyRegistry> {
    let owner_addr = signer::address_of(owner);
    let registry = StrategyRegistry {
        strategies: vector::empty(),
        next_strategy_id: 1,
    };
    object::create_object(owner, registry)
}

/// Register a new arbitrage strategy
///
/// # Parameters
/// - `registry_obj`: The strategy registry object
/// - `owner`: The strategy owner
/// - `source_dex`: Source DEX identifier
/// - `target_dex`: Target DEX identifier
/// - `min_profit_threshold`: Minimum profit threshold in microIOTA
/// - `max_trade_amount`: Maximum amount per trade
/// - `name`: Strategy name/description
///
/// # Returns
/// The assigned strategy ID
public fun register_strategy(
    registry_obj: Object<StrategyRegistry>,
    owner: &signer,
    source_dex: u64,
    target_dex: u64,
    min_profit_threshold: u64,
    max_trade_amount: u64,
    name: vector<u8>
): u64 {
    let owner_addr = signer::address_of(owner);
    let registry = object::borrow_mut(registry_obj);
    
    assert!(source_dex != target_dex, error::invalid_argument(E_INVALID_PARAMETERS));
    assert!(min_profit_threshold > 0, error::invalid_argument(E_INVALID_PARAMETERS));
    assert!(max_trade_amount > 0, error::invalid_argument(E_INVALID_PARAMETERS));
    
    let strategy_id = registry.next_strategy_id;
    registry.next_strategy_id = registry.next_strategy_id + 1;
    
    let strategy = ArbStrategy {
        owner: owner_addr,
        strategy_id,
        source_dex,
        target_dex,
        min_profit_threshold,
        max_trade_amount,
        is_active: true,
        name,
    };
    
    vector::push_back(&mut registry.strategies, strategy);
    strategy_id
}

/// Update an existing strategy
///
/// # Parameters
/// - `registry_obj`: The strategy registry object
/// - `owner`: The strategy owner
/// - `strategy_id`: The strategy ID to update
/// - `min_profit_threshold`: New minimum profit threshold (0 to keep unchanged)
/// - `max_trade_amount`: New maximum trade amount (0 to keep unchanged)
public fun update_strategy(
    registry_obj: Object<StrategyRegistry>,
    owner: &signer,
    strategy_id: u64,
    min_profit_threshold: u64,
    max_trade_amount: u64
) {
    let owner_addr = signer::address_of(owner);
    let registry = object::borrow_mut(registry_obj);
    
    let len = vector::length(&registry.strategies);
    let mut i = 0;
    
    while (i < len) {
        let strategy = vector::borrow_mut(&mut registry.strategies, i);
        if (strategy.strategy_id == strategy_id) {
            assert!(strategy.owner == owner_addr, error::permission_denied(E_NOT_STRATEGY_OWNER));
            
            if (min_profit_threshold > 0) {
                strategy.min_profit_threshold = min_profit_threshold;
            };
            if (max_trade_amount > 0) {
                strategy.max_trade_amount = max_trade_amount;
            };
            return
        };
        i = i + 1;
    };
    
    abort error::not_found(E_STRATEGY_NOT_FOUND)
}

/// Enable or disable a strategy
///
/// # Parameters
/// - `registry_obj`: The strategy registry object
/// - `owner`: The strategy owner
/// - `strategy_id`: The strategy ID
/// - `is_active`: Whether to enable (true) or disable (false)
public fun set_strategy_active(
    registry_obj: Object<StrategyRegistry>,
    owner: &signer,
    strategy_id: u64,
    is_active: bool
) {
    let owner_addr = signer::address_of(owner);
    let registry = object::borrow_mut(registry_obj);
    
    let len = vector::length(&registry.strategies);
    let mut i = 0;
    
    while (i < len) {
        let strategy = vector::borrow_mut(&mut registry.strategies, i);
        if (strategy.strategy_id == strategy_id) {
            assert!(strategy.owner == owner_addr, error::permission_denied(E_NOT_STRATEGY_OWNER));
            strategy.is_active = is_active;
            return
        };
        i = i + 1;
    };
    
    abort error::not_found(E_STRATEGY_NOT_FOUND)
}

/// Get strategy information by ID
/// This is a friend function for arb_executor to query strategies
///
/// # Parameters
/// - `registry_obj`: The strategy registry object
/// - `strategy_id`: The strategy ID
///
/// # Returns
/// Option containing strategy details if found
public(friend) fun get_strategy(
    registry_obj: Object<StrategyRegistry>,
    strategy_id: u64
): option::Option<ArbStrategy> {
    let registry = object::borrow(registry_obj);
    
    let len = vector::length(&registry.strategies);
    let mut i = 0;
    
    while (i < len) {
        let strategy = vector::borrow(&registry.strategies, i);
        if (strategy.strategy_id == strategy_id && strategy.is_active) {
            return option::some(*strategy)
        };
        i = i + 1;
    };
    
    option::none()
}

/// Get all active strategies for a user
///
/// # Parameters
/// - `registry_obj`: The strategy registry object
/// - `owner`: The owner address
///
/// # Returns
/// Vector of strategy IDs
public fun get_user_strategies(
    registry_obj: Object<StrategyRegistry>,
    owner: address
): vector<u64> {
    let registry = object::borrow(registry_obj);
    let mut result = vector::empty();
    
    let len = vector::length(&registry.strategies);
    let mut i = 0;
    
    while (i < len) {
        let strategy = vector::borrow(&registry.strategies, i);
        if (strategy.owner == owner && strategy.is_active) {
            vector::push_back(&mut result, strategy.strategy_id);
        };
        i = i + 1;
    };
    
    result
}

/// Get strategy count in registry
public fun get_strategy_count(registry_obj: Object<StrategyRegistry>): u64 {
    let registry = object::borrow(registry_obj);
    vector::length(&registry.strategies)
}

