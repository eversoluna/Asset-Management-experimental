// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./external/AaveIntegration.sol";
import "./external/CompoundIntegration.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title YieldAggregator
/// @notice Aggregates and reinvests yield from Aave and Compound protocols
contract YieldAggregator is Ownable {

    /// @notice Emitted when yield is aggregated and reinvested
    /// @param user The address of the user for whom yield is aggregated
    /// @param amount The amount of yield aggregated and reinvested
    event YieldAggregated(address indexed user, uint256 amount);

    /// @notice Aggregate and reinvest yield from Aave and Compound
    /// @dev Only callable by the contract owner
    /// @param user The address of the user for whom yield is aggregated
    /// @param amount The amount of yield to aggregate and reinvest
    function aggregateYield(address user, uint256 amount) external onlyOwner {
        require(user != address(0), "Invalid user address");
        require(amount > 0, "Amount must be greater than zero");

        // Logic to aggregate yield from Aave and Compound
        reinvestInAave(user, amount);
        reinvestInCompound(user, amount);

        emit YieldAggregated(user, amount);
    }

    /// @notice Reinvest yield in Aave
    /// @param user The address of the user
    /// @param amount The amount to reinvest
    function reinvestInAave(address user, uint256 amount) internal {
        // Example logic for reinvesting in Aave
        // This assumes AaveIntegration has a deposit function
        AaveIntegration aave = AaveIntegration(address(this));
        aave.deposit(user, amount);
    }

    /// @notice Reinvest yield in Compound
    /// @param user The address of the user
    /// @param amount The amount to reinvest
    function reinvestInCompound(address user, uint256 amount) internal {
        // Example logic for reinvesting in Compound
        // This assumes CompoundIntegration has a deposit function
        CompoundIntegration compound = CompoundIntegration(address(this));
        compound.deposit(user, amount);
    }
}
