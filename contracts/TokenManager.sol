// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";

/// @title TokenManager
/// @notice Manages deposits and withdrawals of ERC20 tokens
contract TokenManager {
    IERC20 public asset;
    mapping(address => uint256) public balances;

    /// @notice Emitted when tokens are deposited
    /// @param user The address of the depositor
    /// @param amount The amount of tokens deposited
    event TokenDeposited(address indexed user, uint256 amount);

    /// @notice Emitted when tokens are withdrawn
    /// @param user The address of the withdrawer
    /// @param amount The amount of tokens withdrawn
    event TokenWithdrawn(address indexed user, uint256 amount);

    /// @notice Constructor to initialize the token manager
    /// @param _asset The address of the ERC20 token managed by this contract
    constructor(address _asset) {
        require(_asset != address(0), "Invalid asset address");
        asset = IERC20(_asset);
    }

    /// @notice Internal function to deposit tokens
    /// @param amount The amount of tokens to deposit
    function depositToken(uint256 amount) internal {
        require(amount > 0, "Amount must be greater than 0");
        require(asset.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");

        bool success = asset.transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed");

        balances[msg.sender] += amount;
        emit TokenDeposited(msg.sender, amount);
    }

    /// @notice Internal function to withdraw tokens
    /// @param amount The amount of tokens to withdraw
    function withdrawToken(uint256 amount) internal {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;

        bool success = asset.transfer(msg.sender, amount);
        require(success, "Token transfer failed");

        emit TokenWithdrawn(msg.sender, amount);
    }
}
