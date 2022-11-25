const Main = artifacts.require("Main");

const marketItemContractAddress = artifacts.require("../contracts/MarketItemMain.sol");
const marketPlaceContractAddress = artifacts.require(
  "../contracts/MarketPlaceMain1155.sol"
);
const refundedContractAddress = artifacts.require("../contracts/Refunded.sol");
const mintFactoryContractAddress = artifacts.require(
  "../contracts/MintFactoryMain1155.sol"
);
const nftContractAddress = artifacts.require(
  "../contracts/NFTContract.sol"
);

module.exports = function (deployer) {
  deployer.deploy(
    Main,
    marketItemContractAddress.address,
    marketPlaceContractAddress.address,
    refundedContractAddress.address,
    mintFactoryContractAddress.address,
    nftContractAddress.address
  );
};
