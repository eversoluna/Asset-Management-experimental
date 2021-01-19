// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ICToken
/// @notice Interface for Compound's cToken contracts
interface ICToken {
    /// @notice Supply an asset to Compound and receive cTokens
    /// @param mintAmount The amount of the underlying asset to supply
    /// @return 0 on success, otherwise an error code
    function mint(uint256 mintAmount) external returns (uint256);

    /// @notice Redeem underlying asset from Compound
    /// @param redeemAmount The amount of the underlying asset to redeem
    /// @return 0 on success, otherwise an error code
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    // Optionally, you can add more functions as needed, such as balanceOf, redeem, etc.
}
