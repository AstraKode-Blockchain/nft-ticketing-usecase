const MarketPlaceMain1155 = artifacts.require('MarketPlaceMain1155');
const MarketItemMain = artifacts.require('MarketItemMain');
const NFTContract = artifacts.require('NFTContract');
const Web3 = require('web3');
const rpcURL = 'http://192.168.128.1:7545';
const objWeb3 = new Web3(rpcURL);

let marketPlace;
let marketItem;

before(async () => {
  marketPlace = await MarketPlaceMain1155.deployed();
  marketItem = await MarketItemMain.deployed();
  nftContract = await NFTContract.deployed();
  //let result2 = await marketPlace.send(web3.utils.toWei(web3.utils.toBN(1), 'ether'));
});

contract('1. Try to send ethers to contract', function (accounts) {
  it('1.1 Check if ethers are received', async () => {
    var contractToReceiveEthers = marketItem.address;
    objWeb3.eth.sendTransaction({to:contractToReceiveEthers, from:accounts[4], value: objWeb3.utils.toWei('10')});
  });
});

contract('2. Market Item test', function (accounts) {
  it('2.1 Check if item created', async () => {
    let balance = await objWeb3.eth.getBalance(marketItem.address);
    assert.equal(balance, 10000000000000000000, "The contract didn't received the ethers");
    var tokenIds = [1];
    var price = 1;
    var amounts = [1];
    marketItem._createMarketItem.call(
      nftContract.address,
      tokenIds,
      price,
      amounts
    );
  });
});

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