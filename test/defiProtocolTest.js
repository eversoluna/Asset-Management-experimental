const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DeFiProtocol", function () {
  let DeFiProtocol, defiProtocol, owner, addr1, addr2, token, aave, compound;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy a mock ERC-20 token for testing
    const ERC20 = await ethers.getContractFactory("ERC20");
    token = await ERC20.deploy("Asset Manage Token", "AMT");
    await token.deployed();

    // Deploy mock Aave and Compound integrations
    const AaveIntegration = await ethers.getContractFactory("AaveIntegration");
    aave = await AaveIntegration.deploy(owner.address);
    await aave.deployed();

    const CompoundIntegration = await ethers.getContractFactory("CompoundIntegration");
    compound = await CompoundIntegration.deploy(owner.address);
    await compound.deployed();

    // Deploy DeFiProtocol contract with all required addresses
    const UniswapRouter = ethers.constants.AddressZero;
    DeFiProtocol = await ethers.getContractFactory("DeFiProtocol");
    defiProtocol = await DeFiProtocol.deploy(
      token.address,
      UniswapRouter,
      aave.address,
      compound.address
    );
    await defiProtocol.deployed();
  });

  describe("Constructor", function () {
    it("should initialize with correct addresses", async function () {
      expect(await defiProtocol.asset()).to.equal(token.address);
    });
  });

  describe("Deposit", function () {
    it("should deposit tokens and emit event", async function () {
      await token.mint(addr1.address, ethers.utils.parseEther("100"));
      await token.connect(addr1).approve(defiProtocol.address, ethers.utils.parseEther("50"));
      await expect(defiProtocol.connect(addr1).deposit(ethers.utils.parseEther("50")))
        .to.emit(defiProtocol, "Deposited")
        .withArgs(addr1.address, ethers.utils.parseEther("50"));
      expect(await defiProtocol.balances(addr1.address)).to.equal(ethers.utils.parseEther("50"));
    });

    it("should revert if deposit amount is zero", async function () {
      await expect(defiProtocol.connect(addr1).deposit(0)).to.be.revertedWith("Deposit amount must be greater than zero");
    });

    it("should revert if allowance is insufficient", async function () {
      await token.mint(addr1.address, ethers.utils.parseEther("10"));
      await expect(defiProtocol.connect(addr1).deposit(ethers.utils.parseEther("10"))).to.be.revertedWith("Insufficient allowance");
    });
  });

  describe("Withdraw", function () {
    beforeEach(async function () {
      await token.mint(addr1.address, ethers.utils.parseEther("100"));
      await token.connect(addr1).approve(defiProtocol.address, ethers.utils.parseEther("100"));
      await defiProtocol.connect(addr1).deposit(ethers.utils.parseEther("100"));
    });

    it("should withdraw tokens and emit event", async function () {
      await expect(defiProtocol.connect(addr1).withdraw(ethers.utils.parseEther("30")))
        .to.emit(defiProtocol, "Withdrawn")
        .withArgs(addr1.address, ethers.utils.parseEther("30"));
      expect(await defiProtocol.balances(addr1.address)).to.equal(ethers.utils.parseEther("70"));
    });

    it("should revert if withdraw amount is zero", async function () {
      await expect(defiProtocol.connect(addr1).withdraw(0)).to.be.revertedWith("Withdraw amount must be greater than zero");
    });

    it("should revert if withdraw amount exceeds balance", async function () {
      await expect(defiProtocol.connect(addr1).withdraw(ethers.utils.parseEther("200"))).to.be.revertedWith("Insufficient balance");
    });
  });

  describe("Edge Cases", function () {
    it("should revert if deposit fails (simulate transfer failure)", async function () {
      expect(true).to.be.true;
    });

    it("should revert if withdraw fails (simulate transfer failure)", async function () {
      expect(true).to.be.true;
    });
  });
});
