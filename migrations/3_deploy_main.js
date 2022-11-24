const Main = artifacts.require("Main");

const marketItemContractAddress = artifacts.require("./MarketItemMain.sol");
const marketPlaceContractAddress = artifacts.require(
  "./MarketPlaceMain1155.sol"
);
const refundedContractAddress = artifacts.require("./Refunded.sol");
const mintFactoryContractAddress = artifacts.require(
  "./MintFactoryMain1155.sol"
);

module.exports = function (deployer) {
  deployer.deploy(
    Main,
    marketItemContractAddress.address,
    marketPlaceContractAddress.address,
    refundedContractAddress.address,
    mintFactoryContractAddress.address
  );
};
