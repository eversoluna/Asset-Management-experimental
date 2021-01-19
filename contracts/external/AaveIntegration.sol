// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IAaveLendingPool.sol";

/// @title AaveIntegration
/// @notice Integrates with Aave's lending pool for deposits and withdrawals
contract AaveIntegration {

    IAaveLendingPool public aaveLendingPool;

    /// @notice Emitted when a deposit is made to Aave
    /// @param asset The address of the asset deposited
    /// @param amount The amount of the asset deposited
    /// @param user The address of the user making the deposit
    event Deposited(address indexed asset, uint256 amount, address indexed user);

    /// @notice Emitted when a withdrawal is made from Aave
    /// @param asset The address of the asset withdrawn
    /// @param amount The amount of the asset withdrawn
    /// @param user The address of the user making the withdrawal
    event Withdrawn(address indexed asset, uint256 amount, address indexed user);

    /// @notice Constructor to initialize the Aave lending pool
    /// @param _aaveLendingPool The address of the Aave lending pool contract
    constructor(address _aaveLendingPool) {
        require(_aaveLendingPool != address(0), "Invalid Aave lending pool address");
        aaveLendingPool = IAaveLendingPool(_aaveLendingPool);
    }

    /// @notice Deposit assets into Aave
    /// @param asset The address of the asset to deposit
    /// @param amount The amount of the asset to deposit
    function deposit(address asset, uint256 amount) external {
        require(asset != address(0), "Invalid asset address");
        require(amount > 0, "Amount must be greater than zero");

        aaveLendingPool.deposit(asset, amount, msg.sender, 0);
        emit Deposited(asset, amount, msg.sender);
    }

    /// @notice Withdraw assets from Aave
    /// @param asset The address of the asset to withdraw
    /// @param amount The amount of the asset to withdraw
    function withdraw(address asset, uint256 amount) external {
        require(asset != address(0), "Invalid asset address");
        require(amount > 0, "Amount must be greater than zero");

        aaveLendingPool.withdraw(asset, amount, msg.sender);
        emit Withdrawn(asset, amount, msg.sender);
    }
}
