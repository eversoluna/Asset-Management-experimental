// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/ICompoundComptroller.sol";
import "../interfaces/ICToken.sol";

/// @title CompoundIntegration
/// @notice Integrates with Compound's Comptroller for deposits and withdrawals
contract CompoundIntegration {

    ICompoundComptroller public compoundComptroller;

    /// @notice Emitted when a deposit is made to Compound
    /// @param cToken The address of the cToken representing the asset deposited
    /// @param amount The amount of the asset deposited
    /// @param user The address of the user making the deposit
    event Deposited(address indexed cToken, uint256 amount, address indexed user);

    /// @notice Emitted when a withdrawal is made from Compound
    /// @param cToken The address of the cToken representing the asset withdrawn
    /// @param amount The amount of the asset withdrawn
    /// @param user The address of the user making the withdrawal
    event Withdrawn(address indexed cToken, uint256 amount, address indexed user);

    /// @notice Constructor to initialize the Compound Comptroller
    /// @param _compoundComptroller The address of the Compound Comptroller contract
    constructor(address _compoundComptroller) {
        require(_compoundComptroller != address(0), "Invalid Compound Comptroller address");
        compoundComptroller = ICompoundComptroller(_compoundComptroller);
    }

    /// @notice Deposit assets into Compound
    /// @param cToken The address of the cToken representing the asset to deposit
    /// @param amount The amount of the asset to deposit
    function deposit(address cToken, uint256 amount) external {
        require(cToken != address(0), "Invalid cToken address");
        require(amount > 0, "Amount must be greater than zero");

        ICToken token = ICToken(cToken);
        require(token.mint(amount) == 0, "Compound deposit failed");

        emit Deposited(cToken, amount, msg.sender);
    }

    /// @notice Withdraw assets from Compound
    /// @param cToken The address of the cToken representing the asset to withdraw
    /// @param amount The amount of the asset to withdraw
    function withdraw(address cToken, uint256 amount) external {
        require(cToken != address(0), "Invalid cToken address");
        require(amount > 0, "Amount must be greater than zero");

        ICToken token = ICToken(cToken);
        require(token.redeemUnderlying(amount) == 0, "Compound withdrawal failed");

        emit Withdrawn(cToken, amount, msg.sender);
    }
}
