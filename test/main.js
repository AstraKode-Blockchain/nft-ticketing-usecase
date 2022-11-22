const MarketPlaceMain1155 = artifacts.require('MarketPlaceMain1155');
const MarketItemMain = artifacts.require('MarketItemMain');
const NFTContract = artifacts.require('NFTContract');
const Web3 = require('web3');
const rpcURL = 'http://172.30.64.1:7545';
const objWeb3 = new Web3(rpcURL);
const assert = require('assert');


let marketPlace;
let marketItem;
let nftContract;

before(async () => {
  marketPlace = await MarketPlaceMain1155.deployed();
  marketItem = await MarketItemMain.deployed();
  nftContract = await NFTContract.deployed();
});

contract('1. Market Item test', function (accounts) {
  it('1.1 Send ethers to a contract (MarketItemMain)', async () => {
    var contractToReceiveEthers = marketItem.address;
    await objWeb3.eth.sendTransaction({to:contractToReceiveEthers, from:accounts[5], value: objWeb3.utils.toWei('10')});
  });

  it('1.2 Send ethers to a contract (MarketPlaceMain1155)', async () => {
    var contractToReceiveEthers = marketPlace.address;
    await objWeb3.eth.sendTransaction({to:contractToReceiveEthers, from:accounts[6], value: objWeb3.utils.toWei('10')});
  });

  it('1.3 Check if ethers are received (MarketItemMain)', async () => {
    let balance = await objWeb3.eth.getBalance(marketItem.address);
    assert(balance > 0, "The contract didn't received the ethers");
    console.log(balance.toString());
  });

  it('1.4 Check if ethers are received (MarketPlaceMain1155)', async () => {
    let balance = await objWeb3.eth.getBalance(marketPlace.address);
    assert(balance > 0, "The contract didn't received the ethers");
    console.log(balance.toString());
  });

  it('1.5 Try to approve the NFT', async () => {
    await nftContract.setApprovalForAll.call(marketItem.address, true);
  });

  it('1.6 Check if item created', async () => {
    var tokenIds = [1];
    var price = 1;
    var amounts = [1];
    await marketItem._createMarketItem(
      nftContract.address,
      tokenIds,
      price,
      amounts
    );
  });
});

// contract('2. Market Place test', function (accounts) {
//   it('2.1 Send ethers to a contract', async () => {
//     var contractToReceiveEthers = marketPlace.address;
//     objWeb3.eth.sendTransaction({to:contractToReceiveEthers, from:accounts[6], value: objWeb3.utils.toWei('10')});
//   });

//   it('2.2 Check if ethers are received', async () => {
//     let balance = await objWeb3.eth.getBalance(marketPlace.address);
//     assert(balance > 0, "The contract didn't received the ethers");
//   });

  // it('2.3 Fetch all the market items', async () => {
  //   marketPlace._fetchMarketItems.call();
  // });
// });

/*contract('3. Market place test', function (accounts) {
  it('3.1 Check if deployer address equal to owner address', async () => {
    var owner_address = await marketPlace.owner.call();
    var deployer_add = accounts[0];
    assert.equal(owner_address, deployer_add, 'mess');
  });

  it('3.1 Fetch all the market items', async () => {
    marketPlace._fetchMarketItems.call();
  });
});*/