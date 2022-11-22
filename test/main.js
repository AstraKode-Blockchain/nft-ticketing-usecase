const NFTContract = artifacts.require('NFTContract');
const Main = artifacts.require('Main');
const Web3 = require('web3');
const rpcURL = 'http://172.30.64.1:7545';
const objWeb3 = new Web3(rpcURL);
const assert = require('assert');

let nftContract;
let temp 

before(async () => {
  nftContract = await NFTContract.deployed();
  mainContract = await Main.deployed();
});

contract('1. Market Item test', function (accounts) {
  it('1.1 Try to approve the NFT', async () => {
    await nftContract.setApprovalForAll(mainContract.address, true);
  });

  it('1.2 Check if item created', async () => {
    var tokenIds = [1];
    var price = 1;
    var amounts = [1];
    await mainContract.createMarketItem(
      nftContract.address,
      tokenIds,
      price,
      amounts
    );
  });
});