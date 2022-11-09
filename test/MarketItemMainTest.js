const { assert } = require('console');
const truffleAssert = require('truffle-assertions');

const MarketItemMain = artifacts.require('MarketItemMain');

let marketItem;


contract('Market Item Main Test ', async () => {

  before(async () => {
    marketItem = await MarketItemMain.deployed();
  });

  describe('1.1 Basic', function (accounts) {
    it('1.1.1 Try to create market item', async () => {
      var nftContract = "0xDF628A31DC031b61CEc48518851dbf6B6154c1a7";
      var tokenIds = [1];
      var price = 10;
      var amounts = [1];
      assert.apply(marketItem._createMarketItem, [
        nftContract,
        tokenIds,
        price,
        amounts,
      ]);
    });
  });
});
