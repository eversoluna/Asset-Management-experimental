// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICompoundComptroller {
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
    function exitMarket(address cToken) external returns (uint);
}
