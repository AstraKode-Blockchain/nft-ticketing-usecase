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

  deployer.deploy(Counters);
  deployer.deploy(MarketItemData);
  deployer.deploy(RefundedData);
  deployer.deploy(ContractCreated);

  deployer.link(Counters, MarketItemMain);
  deployer.link(MarketItemData, MarketItemMain);
  deployer.deploy(MarketItemMain);

  deployer.link(Counters, MarketPlaceMain1155);
  deployer.link(MarketItemData, MarketPlaceMain1155);
  deployer.deploy(MarketPlaceMain1155);

  deployer.deploy(GetInfected);

  deployer.link(Counters, MintFactoryMain1155);
  deployer.link(ContractCreated, MintFactoryMain1155);
  deployer.deploy(MintFactoryMain1155, accounts[1], accounts[2]);

  deployer.deploy(NFTContract, "https://www.google.com/", [1], [1], accounts[0]);

  deployer.link(Counters, Refunded);
  deployer.link(RefundedData, Refunded);
  deployer.deploy(Refunded);
}
