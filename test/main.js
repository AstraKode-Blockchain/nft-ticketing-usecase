let MarketPlaceMain1155 = artifacts.require('MarketPlaceMain1155');
let MarketItemMain = artifacts.require('MarketItemMain');
let NFTContract = artifacts.require('NFTContract');
const Web3 = require('web3');
const rpcURL = 'http://192.168.128.1:7545';
const objWeb3 = new Web3(rpcURL);

let marketPlace;
let marketItem;
let nftContract;

before(async () => {
  marketPlace = await MarketPlaceMain1155.at('0xf3280b68cb42Ca422880e4c38E54bF398Fd81cF8');
  marketItem = await MarketItemMain.at('0x2dd7107A1118b2Ec62D9Ead0EA702A358906BD30');
  nftContract = await NFTContract.at('0x1B9A3EEdFC263D07baE5BC97a183b1Cb848a8355');
  //let result2 = await marketPlace.send(web3.utils.toWei(web3.utils.toBN(1), 'ether'));
});

contract('1. Try to send ethers to contract', function (accounts) {
  it('1.1 Check if ethers are received', async () => {
    var contractToReceiveEthers = marketItem.address;
    await objWeb3.eth.sendTransaction({to:contractToReceiveEthers, from:accounts[4], value: objWeb3.utils.toWei('10')});
    let balance = objWeb3.utils.toWei('10');
    let newBalance = await objWeb3.eth.getBalance(contractToReceiveEthers);
    assert.equal(balance, newBalance, "The contract didn't received the ethers");
  });
});

contract('2. Market Item test', function (accounts) {
  it('2.1 Check if item created', async () => {
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