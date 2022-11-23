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
  nftContract = await NFTContract.at('0x81bC941a352d0e3C7F836431343b168214B2acCe');
  mainContract = await Main.at('0xF08205b6bb29a576Ff0Edda289716dDcAB27969A');
  marketItem = await MarketItemMain.at('0x0Ea2537DB6E3742445b4d25b543660fB8B5A8635');
});

contract('1. Market Item test', function (accounts) {
  it('1.1 Try to approve the NFT', async () => {
    await nftContract.setApprovalForAll(mainContract.address, true);
    await nftContract.setApprovalForAll(marketItem.address, true);
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

  it('1.3 Fetch market items' , async () => {
    console.log(await mainContract.fetchMarketItems.call())
  });
});