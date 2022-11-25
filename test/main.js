const NFTContract = artifacts.require('../contracts/NFTContract.sol');
const Main = artifacts.require('../contracts/Main.sol');
const MarketItemMain = artifacts.require('../contracts/MarketItemMain');
const MarketPlaceMain1155 = artifacts.require('../contracts/MarketPlaceMain1155');
const assert = require('assert');
const Web3 = require("web3");
let web3 = new Web3(Web3.givenProvider || "ws://172.30.64.1:7545");

let nftContract;
let mainContract;
let marketItemContract;
//let marketPlaceContract;


before(async () => {
  nftContract = await NFTContract.deployed();
  mainContract = await Main.deployed();
  marketItemContract = await MarketItemMain.deployed();
  //marketPlaceContract = await MarketPlaceMain1155.deployed();
});

contract('1. Main contract test', function (accounts) {
  it('1.1 Try to approve the main contract', async () => {
    await nftContract.setApprovalForAll(mainContract.address, true);
    var flag = await nftContract.isApprovedForAll(accounts[0], mainContract.address);
    assert(flag, "A contract address has not been approved by the NFT contract");
  });

  it('1.2 Try to approve the market item contract', async () => {
    await nftContract.setApprovalForAll(marketItemContract.address, true);
    var flag = await nftContract.isApprovedForAll(accounts[0], marketItemContract.address);
    assert(flag, "A contract address has not been approved by the NFT contract"); 
  });

  // it('1.3 Try to approve the market place contract', async () => {
  //   await nftContract.setApprovalForAll(marketPlaceContract.address, true);
  //   var flag = await nftContract.isApprovedForAll(accounts[0], marketPlaceContract.address);
  //   assert(flag, "A contract address has not been approved by the NFT contract"); 
  // });

  it('1.4 Fetch market items' , async () => {
    console.log(await mainContract.fetchMarketItems.call())
  });

  it('1.5 Check if item created', async () => {
    var tokenIds = [1];
    var price = web3.utils.toWei('0.5','ether');
    var amounts = [1];
    await mainContract.createMarketItem(
      nftContract.address,
      tokenIds,
      price,
      amounts
    );
  });

  it('1.6 Try to create a sale', async () => {
    var itemId = 1;
    var tokenIds = 1;
    var amounts = [1];
    await mainContract.createMarketSale(
      nftContract.address,
      itemId,
      tokenIds,
      amounts, { value: web3.utils.toWei('0.5','ether'), from: accounts[1] }
    );
  });

  // it('1.7 Try to add refund parameters', async () => {
  //   await mainContract.addRefundParameters(nftContract.address, 100000, 1, 1);
  // });

  // it('1.8 Try to fetch refund parameters', async () => {
  //   console.log(await mainContract.fetchParameters.call(1));
  // });
});