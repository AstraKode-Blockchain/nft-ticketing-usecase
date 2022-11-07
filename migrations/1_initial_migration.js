const MarketPlaceMain1155 = artifacts.require("MarketPlaceMain1155");
const Main = artifacts.require("Main");

module.exports = function (deployer) {
  deployer.deploy(Main);
  deployer.deploy(MarketPlaceMain1155);
};
