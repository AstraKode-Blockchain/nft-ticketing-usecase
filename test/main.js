const NFTContract = artifacts.require('NFTContract');
const Main = artifacts.require('Main');
const MarketItemMain = artifacts.require('MarketItemMain');
const Web3 = require('web3');
const rpcURL = 'http://172.30.64.1:7545';
const objWeb3 = new Web3(rpcURL);
const assert = require('assert');

let nftContract;
let mainContract;
let marketItem;

before(async () => {
  nftContract = await NFTContract.deployed();
  mainContract = await Main.deployed();
  marketItem = await MarketItemMain.deployed();
});

contract('1. Main contract test', function (accounts) {
  it('1.1 Try to approve the NFT', async () => {
    await nftContract.setApprovalForAll(mainContract.address, true);
  });

  it('1.2 Check if item created', async () => {
    var tokenIds = [1];
    var price = 1;
    var amounts = [1];
    console.log(mainContract.address)
    await mainContract.createMarketItem(
      nftContract.address,
      tokenIds,
      price,
      amounts
    );
  });

  // it('1.3 Fetch market items' , async () => {
  //   console.log(await mainContract.fetchMarketItems.call())
  // });

  // it('1.2 Try to add refund parameters', async () => {
  //   await mainContract.addRefundParameters(nftContract.address, 100000, 1, 1);
  // });

  // it('1.3 Try to fetch refund parameters', async () => {
  //   console.log(await mainContract.fetchParameters.call(1));
  // });
});