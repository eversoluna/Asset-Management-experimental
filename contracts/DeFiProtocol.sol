// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenManager.sol";
import "./Rebalancer.sol";
import "./RiskManager.sol";
import "./YieldAggregator.sol";
import "./external/AaveIntegration.sol";
import "./external/CompoundIntegration.sol";

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @title DeFiProtocol
/// @notice Main protocol contract integrating multiple DeFi modules
/// @dev Inherits TokenManager, Rebalancer, RiskManager, YieldAggregator, AaveIntegration, CompoundIntegration
contract DeFiProtocol is TokenManager, Rebalancer, RiskManager, YieldAggregator, AaveIntegration, CompoundIntegration, ReentrancyGuard {
    /// @notice Emitted when a deposit is made
    /// @param user The address of the depositor
    /// @param amount The amount deposited
    event Deposited(address indexed user, uint256 amount);

    /// @notice Emitted when a withdrawal is made
    /// @param user The address of the withdrawer
    /// @param amount The amount withdrawn
    event Withdrawn(address indexed user, uint256 amount);

    /// @notice Constructor to initialize all modules
    /// @param _asset The asset address
    /// @param _uniswapRouter The Uniswap router address
    /// @param _aaveLendingPool The Aave lending pool address
    /// @param _compoundComptroller The Compound comptroller address
    constructor(
        address _asset,
        address _uniswapRouter,
        address _aaveLendingPool,
        address _compoundComptroller
    )
        TokenManager(_asset)
        Rebalancer(_aaveLendingPool, _compoundComptroller)
        RiskManager()
        YieldAggregator()
        AaveIntegration(_aaveLendingPool)
        CompoundIntegration(_compoundComptroller)
    {
        // All modules initialized via base constructors
    }


    /// @notice Deposit tokens into the protocol
    /// @param amount The amount to deposit
    function deposit(uint256 amount)
        public
        override
        nonReentrant
    {
        require(amount > 0, "Deposit amount must be greater than zero");
        uint256 prevBalance = balances[msg.sender];
        depositToken(amount);
        uint256 newBalance = balances[msg.sender];
        require(newBalance > prevBalance, "Deposit failed");
        emit Deposited(msg.sender, amount);
    }

    /// @notice Withdraw tokens from the protocol
    /// @param amount The amount to withdraw
    function withdraw(uint256 amount)
        public
        override
        nonReentrant
    {
        require(amount > 0, "Withdraw amount must be greater than zero");
        uint256 prevBalance = balances[msg.sender];
        withdrawToken(amount);
        uint256 newBalance = balances[msg.sender];
        require(newBalance < prevBalance, "Withdraw failed");
        emit Withdrawn(msg.sender, amount);
    }
}
