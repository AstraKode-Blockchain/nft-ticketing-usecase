const NFTContract = artifacts.require("../contracts/NFTContract.sol");
const Main = artifacts.require("../contracts/Main.sol");
const MarketItemMain = artifacts.require("../contracts/MarketItemMain");
const Refunded = artifacts.require("../contracts/Refunded");
const truffleAssert = require("truffle-assertions");
const MintFactoryMain1155 = artifacts.require(
  "../contracts/MintFactoryMain1155"
);
const MarketPlaceMain1155 = artifacts.require(
  "../contracts/MarketPlaceMain1155"
);
const Attacker = artifacts.require("../utils/Attacker.sol");
const assert = require("assert");
var Web3EthContract = require("web3-eth-contract");
Web3EthContract.setProvider("ws://localhost:7545");

const isRefundEnabled = false;
let nftContract;
let mainContract;
let marketItemContract;
let marketPlaceContract;
let refundedContract;
let mintFactory;
let nftAddress;
let refundedAddress;
let attackerAddress;

contract("1. Main contract test", function (accounts) {
  before(async () => {
    nftContract = await NFTContract.deployed();
    console.log(accounts[0]);

    marketItemContract = await MarketItemMain.deployed();
    marketPlaceContract = await MarketPlaceMain1155.deployed();
    mintFactory = await MintFactoryMain1155.deployed(accounts[0], accounts[0]);
    attackerAddress = await Attacker.deployed(marketItemContract.address);

    if (isRefundEnabled) {
      refundedContract = await Refunded.deployed();
      refundedAddress = refundedContract.address;
    } else {
      refundedAddress = "0x0000000000000000000000000000000000000000";
    }

    var res = await mintFactory._deployCollection(
      "uri",
      [1, 2],
      [1, 1],
      "name",
      "image",
      1000,
      "date"
    );

    nftAddress = res.logs[0].args.newAddress;
    console.log(nftAddress);
    nftContract = await NFTContract.at(nftAddress);

    mainContract = await Main.deployed(
      marketPlaceContract.address,
      refundedAddress,
      mintFactory.address,
      nftAddress
    );
  });

  it("1.1 Try to approve the main contract", async () => {
    await nftContract.setApprovalForAll(mainContract.address, true);
    var flag = await nftContract.isApprovedForAll(
      accounts[0],
      mainContract.address
    );
    assert(
      flag,
      "A contract address has not been approved by the NFT contract"
    );
  });

  it("1.2 Try to approve the market item contract", async () => {
    await nftContract.setApprovalForAll(marketItemContract.address, true);
    var flag = await nftContract.isApprovedForAll(
      accounts[0],
      marketItemContract.address
    );
    assert(
      flag,
      "A contract address has not been approved by the NFT contract"
    );
  });

  it("1.3 Try to approve the market place contract", async () => {
    await nftContract.setApprovalForAll(marketPlaceContract.address, true);
    var flag = await nftContract.isApprovedForAll(
      accounts[0],
      marketPlaceContract.address
    );
    assert(
      flag,
      "A contract address has not been approved by the NFT contract"
    );
  });
  it("1.4 Fetch market items", async () => {
    console.log(await mainContract.fetchMarketItems());
  });

  it("1.5 Check if item created", async () => {
    var tokenIds = [1];
    var price = web3.utils.toWei("0.01", "ether");
    var amounts = [1];
    var returnValues = await mainContract.createMarketItem(
      nftContract.address,
      tokenIds,
      price,
      amounts
    );
    nftAdd = returnValues.logs[0].args.nftContract;
    console.log(nftAdd);
  });

  it("1.6 Try to create a sale", async () => {
    var price = web3.utils.toWei("0.02", "ether");
    // await web3.eth.sendTransaction({to:marketPlaceContract.address, from:accounts[5], value: price});
    var itemId = 1;
    var tokenIds = [1];
    var amounts = [1];
    await mainContract.createMarketSale(
      nftContract.address,
      itemId,
      tokenIds,
      amounts,
      { value: price }
    );
    let balance = await web3.eth.getBalance(mainContract.address);
    console.log(balance);
    let balance2 = await web3.eth.getBalance(marketPlaceContract.address);
    console.log(balance2);
    //check if you have nft erc1155 get balance of
  });

  it("1.8 Try to add refund parameters", async () => {
    console.log("Refunded address: " + refundedAddress);
    if (refundedAddress != "0x0000000000000000000000000000000000000000") {
      var price = web3.utils.toWei("0.01", "ether");
      var event = await mainContract.addRefundParameters(
        nftContract.address,
        100000,
        price,
        1
      );

      truffleAssert.eventEmitted(event, "RefundParametersAdded");

      assert.equal(
        event.logs[0].event,
        "RefundParametersAdded",
        "Invalid event emitted"
      );
    } else {
      console.log("Refunds not enabled");
    }
  });

  it("1.9 Try to fetch refund parameters", async () => {
    if (refundedAddress != "0x0000000000000000000000000000000000000000") {
      var price = web3.utils.toWei("0.01", "ether");
      var result = await mainContract.fetchParameters.call(1);
      console.log("---------------------------------");
      console.log(result);
      assert.equal(result[0], 1, "Error: Invalid item id");
      assert.equal(
        result[1],
        nftContract.address,
        "Error: Invalid NFT contract address"
      );
      assert.equal(result[3], price, "Error: Invalid price");
      assert.equal(result[4], 100000, "Error: Invalid maxInfection");
    } else {
      console.log("Refunds not enabled");
    }
  });

  it("1.10 Try to refund client", async () => {
    if (refundedAddress != "0x0000000000000000000000000000000000000000") {
      var price = web3.utils.toWei("0.02", "ether");
      var beforeRefund = await web3.eth.getBalance(accounts[1]);
      await mainContract.refundUsers([accounts[1]], 1, { value: price });
      var afterRefund = await web3.eth.getBalance(accounts[1]);
      assert.notEqual(
        beforeRefund,
        afterRefund,
        "Error: The account didn't refunded"
      );
    } else {
      console.log("Refunds not enabled");
    }
  });

  // it("1.11 Try to attack market item contract", async () => {
  //   var tokenIds = [1];
  //   var price = web3.utils.toWei("0.01", "ether");
  //   var amounts = [1];
  //   var returnValues = await attackerAddress.attack(
  //     nftContract.address,
  //     tokenIds,
  //     price,
  //     amounts
  //   );
  //   nftAdd = returnValues.logs[0].args.nftContract;
  //   console.log(nftAdd);
  // });

});
