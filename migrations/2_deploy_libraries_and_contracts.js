const Web3 = require("web3");
const Counters = artifacts.require('Counters');
const MarketItemData = artifacts.require('MarketItemData');
const RefundedData = artifacts.require('RefundedData');
const ContractCreated = artifacts.require('ContractCreated');
const MarketItemMain = artifacts.require('MarketItemMain');
const MarketPlaceMain1155 = artifacts.require('MarketPlaceMain1155');
const GetInfected = artifacts.require('GetInfected');
const MintFactoryMain1155 = artifacts.require('MintFactoryMain1155');
const Refunded = artifacts.require('Refunded');
const NFTContract = artifacts.require('NFTContract');
let web3 = new Web3(Web3.givenProvider || "ws://172.30.64.1:7545");
let accounts;

module.exports = async function (deployer) {

  try {
    accounts = await web3.eth.getAccounts();
    console.log(accounts);
  } catch (error) {
    console.error(error);
  }

  await deployer.deploy(Counters);
  await deployer.deploy(MarketItemData);
  await deployer.deploy(RefundedData);
  await deployer.deploy(ContractCreated);

  await deployer.link(Counters, MarketItemMain);
  await deployer.link(MarketItemData, MarketItemMain);
  await deployer.deploy(MarketItemMain);

  await deployer.link(Counters, MarketPlaceMain1155);
  await deployer.link(MarketItemData, MarketPlaceMain1155);
  await deployer.deploy(MarketPlaceMain1155);

  await deployer.deploy(GetInfected);

  await deployer.link(Counters, MintFactoryMain1155);
  await deployer.link(ContractCreated, MintFactoryMain1155);
  await deployer.deploy(MintFactoryMain1155, accounts[1], accounts[2]);

  await deployer.deploy(NFTContract, "https://www.google.com/", [1], [1], accounts[0]);

  await deployer.link(Counters, Refunded);
  await deployer.link(RefundedData, Refunded);
  await deployer.deploy(Refunded);
}
