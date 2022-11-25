const NFTContract = artifacts.require('../contracts/NFTContract.sol');
const Main = artifacts.require('../contracts/Main.sol');
const assert = require('assert');

let nftContract;
let mainContract;


before(async () => {
  nftContract = await NFTContract.at(NFTContract.address);
  mainContract = await Main.at(Main.address);
});

contract('1. Main contract test', function (accounts) {
  it('1.1 Try to approve the NFT', async () => {
    await nftContract.setApprovalForAll(mainContract.address, true);
    assert(await nftContract.isApprovedForAll.call(accounts[0], mainContract.address), "A contract address has not been approved by the NFT contract");
    
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