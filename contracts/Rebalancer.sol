// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./external/AaveIntegration.sol";
import "./external/CompoundIntegration.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Rebalancer
/// @notice Handles rebalancing of assets between Aave and Compound protocols
contract Rebalancer is Ownable {
    AaveIntegration private aave;
    CompoundIntegration private compound;

    /// @notice Emitted when assets are rebalanced
    /// @param asset The asset being rebalanced
    /// @param fromProtocol The protocol from which assets are withdrawn
    /// @param toProtocol The protocol to which assets are deposited
    /// @param amount The amount of assets rebalanced
    event Rebalanced(address indexed asset, string fromProtocol, string toProtocol, uint256 amount);

    /// @notice Constructor to initialize protocol integrations
    /// @param _aave Address of the Aave integration contract
    /// @param _compound Address of the Compound integration contract
    constructor(address _aave, address _compound) {
        aave = AaveIntegration(_aave);
        compound = CompoundIntegration(_compound);
    }

    /// @notice Rebalance assets between Aave and Compound
    /// @param asset The address of the asset to rebalance
    /// @param fromProtocol The protocol to withdraw from ("Aave" or "Compound")
    /// @param toProtocol The protocol to deposit to ("Aave" or "Compound")
    /// @param amount The amount of assets to rebalance
    function rebalance(address asset, string memory fromProtocol, string memory toProtocol, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(asset != address(0), "Invalid asset address");
        require(keccak256(abi.encodePacked(fromProtocol)) != keccak256(abi.encodePacked(toProtocol)), "Protocols must be different");

        if (keccak256(abi.encodePacked(fromProtocol)) == keccak256(abi.encodePacked("Aave"))) {
            aave.withdraw(asset, amount);
            compound.deposit(asset, amount);
        } else if (keccak256(abi.encodePacked(fromProtocol)) == keccak256(abi.encodePacked("Compound"))) {
            compound.withdraw(asset, amount);
            aave.deposit(asset, amount);
        } else {
            revert("Invalid protocol specified");
        }

        emit Rebalanced(asset, fromProtocol, toProtocol, amount);
    }
}
