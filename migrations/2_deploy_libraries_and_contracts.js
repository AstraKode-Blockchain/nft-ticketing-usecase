const Counters = artifacts.require('Counters');
const MarketItemData = artifacts.require('MarketItemData');
const RefundedData = artifacts.require('RefundedData');
const ContractCreated = artifacts.require('ContractCreated');
const MarketItemMain = artifacts.require('MarketItemMain');
const MarketPlaceMain1155 = artifacts.require('MarketPlaceMain1155');
const GetInfected = artifacts.require('GetInfected');
const MintFactoryMain1155 = artifacts.require('MintFactoryMain1155');
const Refunded = artifacts.require('Refunded');
const accounts = [
    "0x752398F6dafcDC224f3d2059Eb8b097812A0E620",
    "0x4314b557D69Cf6Be48c080eDA8CFd0A2ce4B1373",
  ];


module.exports = function (deployer) {
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
  deployer.deploy(MintFactoryMain1155, accounts[0], accounts[1]);

  deployer.link(Counters, Refunded);
  deployer.link(RefundedData, Refunded);
  deployer.deploy(Refunded);
}
