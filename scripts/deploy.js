async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const tokenAddress = process.env.TOKEN_ADDRESS;
    const uniswapRouterAddress = process.env.UNIV2_ROUTER_ADDRESS;
    const aaveLendingPool = process.env.AAVE_LENDING_POOL_ADDRESS;
    const compoundComptroller = process.env.COMPOUND_COMPTROLLER_ADDRESS;

    const DeFiProtocol = await ethers.getContractFactory("DeFiProtocol");
    const defiProtocol = await DeFiProtocol.deploy(tokenAddress, uniswapRouterAddress, aaveLendingPool, compoundComptroller);

    console.log("DeFiProtocol deployed to:", defiProtocol.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
