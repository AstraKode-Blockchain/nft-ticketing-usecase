var assert = require('assert');
const web3 = require('web3');

const MarketPlaceMain1155 = artifacts.require('MarketPlaceMain1155');
const MarketItemMain = artifacts.require('MarketItemMain');

let marketPlace;
let marketItem;

before(async () => {
  marketPlace = await MarketPlaceMain1155.deployed();
  marketItem = await MarketItemMain.deployed();
});

contract('1. Market Item test', function (accounts) {
  it('1. Check if item created', async () => {
    web3.eth.getBalance('0x15Def00C09DeBa36920C9380Fdb32fa8585899dE',function(error,result){
      if(error){
        console.log(error)
      }
      else{
        console.log(result)
      }
    });
    await marketItem.sendTransaction({from: '0x15Def00C09DeBa36920C9380Fdb32fa8585899dE', value:1});
    var nftContract = "0x290d1d9BaD1A86289827e1a709B65Eec813269E0";
    var tokenIds = [1];
    var price = 1;
    var amounts = [1];
    await marketItem._createMarketItem.call(
      nftContract,
      tokenIds,
      price,
      amounts
    );
  });
});

contract('2. Market place test', function (accounts) {
  it('2.1 Check if deployer address equal to owner address', async () => {
    var owner_address = await marketPlace.owner.call();
    var deployer_add = accounts[0];
    assert.equal(owner_address, deployer_add, 'mess');
  });

  it('2.2 Fetch all the market items', async () => {
    var returnValues = await marketPlace._fetchMarketItems.call();
    console.log('     ', returnValues);
  });
});