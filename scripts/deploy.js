async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const tokenAddress = process.env.TOKEN_ADDRESS || "0x47110d43175f7f2C2425E7d15792acC5817EB44f";
    const uniswapRouterAddress = process.env.UNIV2_ROUTER_ADDRESS || "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
    const aaveLendingPool = process.env.AAVE_LENDING_POOL_ADDRESS || "0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9";
    const compoundComptroller = process.env.COMPOUND_COMPTROLLER_ADDRESS || "0x3d9819210a31b4961b30ef54be2aed79b9c9cd3b";

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
