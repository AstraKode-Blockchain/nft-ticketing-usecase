const NFTContract = artifacts.require('NFTContract');
const Main = artifacts.require('Main');

const assert = require('assert');

let nftContract;
let mainContract;


before(async () => {
  nftContract = await NFTContract.deployed();
  mainContract = await Main.deployed();
});

contract('1. Main contract test', function (accounts) {
  it('1.1 Try to approve the NFT', async () => {
    await nftContract.setApprovalForAll(mainContract.address, true);
    assert(await nftContract.isApprovedForAll.call(accounts[0], mainContract.address), "NFT don't approved the contract address");
    
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

  it('1.3 Try to create a sale', async () => {
    var itemId = 1;
    var tokenIds = 1;
    var amounts = [1];
    await mainContract.createMarketSale(
      nftContract.address,
      itemId,
      tokenIds,
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