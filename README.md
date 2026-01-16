# Asset-Management-experimental

This is a modular DeFi protocol built with Solidity and Hardhat, for experimental. It integrates multiple DeFi primitives such as token management, rebalancing, risk management, and yield aggregation, with support for Aave and Compound protocols.

## Features
- **TokenManager**: Secure deposit and withdrawal of ERC20 tokens.
- **Rebalancer**: Move assets between Aave and Compound to optimize yield or manage risk.
- **RiskManager**: Automated risk checks and asset liquidation if exposure exceeds limits.
- **YieldAggregator**: Aggregate and reinvest yield from Aave and Compound.
- **Aave/Compound Integration**: Direct protocol interactions for lending, borrowing, and yield strategies.

## Development
- Built with [Hardhat](https://hardhat.org/)
- Solidity ^0.8.0
- Modular contract architecture for extensibility

## Getting Started
1. Clone the repository
2. Install dependencies: `npm install`
3. Configure your `.env` file for network and private key settings
4. Run tests: `npx hardhat test`
5. Deploy contracts: `npx hardhat run scripts/deploy.js --network <network>`

## Security
- Uses OpenZeppelin contracts for security best practices
- Includes reentrancy guards and access control

## Contribution
Any contribution would be welcome. Please open an issue or PR to contribute in this repo

## License
MIT
