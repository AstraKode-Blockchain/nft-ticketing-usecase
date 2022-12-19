const Web3 = require("web3");
const LinkToken = require("../node_modules/@chainlink/contracts/abi/v0.4/LinkToken.json");
const { fundContractWithLink } = require("../jsutils/fundContract");

const Counters = artifacts.require("Counters");
const MarketItemData = artifacts.require("MarketItemData");
const ContractCreated = artifacts.require("ContractCreated");
const MarketItemMain = artifacts.require("MarketItemMain");
const MarketPlaceMain1155 = artifacts.require("MarketPlaceMain1155");
const GetInfected = artifacts.require("GetInfected");
const MintFactoryMain1155 = artifacts.require("MintFactoryMain1155");
const Refunded = artifacts.require("Refunded");
const NFTContract = artifacts.require("NFTContract");
const Main = artifacts.require("Main");
const RefundedData = artifacts.require("RefundedData");
let web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");

let accounts = ["0xCc403c230E7c0E764122525bC8050Da8c47d8CeD"];

//flag for enabling/disabling refunds
const isRefundEnabled = false;

let linkTokenAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
module.exports = async function (deployer) {
  let refundedAdress = "0x0000000000000000000000000000000000000000";
  //retrieves truffle accounts list instead of hardcoding
  // try {
  //   accounts = await web3.eth.getAccounts();
  //   console.log(accounts);
  // } catch (error) {
  //   console.error(error);
  // }

  await deployer.deploy(Counters);

  await deployer.deploy(MarketItemData);
  await deployer.deploy(ContractCreated);

  await deployer.link(Counters, MarketItemMain);
  await deployer.link(MarketItemData, MarketItemMain);
  await deployer.deploy(MarketItemMain);

  await deployer.link(Counters, MarketPlaceMain1155);
  await deployer.link(MarketItemData, MarketPlaceMain1155);
  await deployer.deploy(MarketPlaceMain1155);
  if (isRefundEnabled) {
    await deployer.deploy(RefundedData);
    await deployer.deploy(GetInfected);
    console.log(GetInfected.address);
    await fundContractWithLink(GetInfected.address);

    await deployer.deploy(Refunded);
    await deployer.link(Counters, Refunded);
    await deployer.link(RefundedData, Refunded);
    console.log("Refunded: " + Refunded.address);
    let refundedAdress = Refunded.address;
    console.log("Refunds Enabled");
  } else {
    console.log("Refunds Disabled");
  }

  await deployer.link(Counters, MintFactoryMain1155);
  await deployer.link(ContractCreated, MintFactoryMain1155);
  await deployer.deploy(MintFactoryMain1155, accounts[0], accounts[0]);

  await deployer.deploy(
    NFTContract,
    "https://www.google.com/",
    [1],
    [1],
    accounts[0]
  );

  await deployer.link(MarketItemData, Main);
  await deployer.deploy(
    Main,
    MarketPlaceMain1155.address,
    refundedAdress,
    MintFactoryMain1155.address,
    NFTContract.address
  );
};
