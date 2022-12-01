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
const assert = require("assert");
const Web3 = require("web3");
var Web3EthContract = require("web3-eth-contract");
Web3EthContract.setProvider("ws://localhost:9545");

let nftContract;
let mainContract;
let marketItemContract;
let marketPlaceContract;
let refundedContract;
let mintFactory;
let nftAddress;

contract("1. Main contract test", function (accounts) {
  before(async () => {
    // nftContract = await NFTContract.deployed();
    console.log(accounts[0]);

    marketItemContract = await MarketItemMain.deployed();
    marketPlaceContract = await MarketPlaceMain1155.deployed();
    mintFactory = await MintFactoryMain1155.deployed(accounts[0], accounts[0]);
    refundedContract = await Refunded.deployed();

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
      refundedContract.address,
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
    var price = web3.utils.toWei("0.5", "ether");
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
    var price = web3.utils.toWei("0.5", "ether");
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
  });

  it("1.7 Try to approve the refunded contract", async () => {
    var event = await nftContract.setApprovalForAll(
      refundedContract.address,
      true
    );
    var flag = await nftContract.isApprovedForAll(
      accounts[0],
      refundedContract.address
    );
    console.log("----------");
    //console.log(event);
    truffleAssert.eventEmitted(event, "ApprovalForAll");

    assert(
      flag,
      "A contract address has not been approved by the NFT contract"
    );

    assert.equal(
      event.logs[0].event,
      "ApprovalForAll",
      "Invalid event emitted"
    );
  });

  it("1.8 Try to add refund parameters", async () => {
    var price = web3.utils.toWei("0.5", "ether");
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
  });

  it("1.9 Try to fetch refund parameters", async () => {
    var price = web3.utils.toWei("0.5", "ether");
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
  });

  // it('1.10 Try to refund client', async () => {
  //   console.log(await mainContract.refundUsers.call([accounts[1]], 1));
  // });
});

it("1.10 Try to refun client", async () => {
  // it('1.10 Try to refund client', async () => {
  //   console.log(await mainContract.refundUsers.call([accounts[1]], 1));
  // });
});
