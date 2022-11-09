const { assert } = require("console");

const MarketItemMain = artifacts.require("MarketItemMain");

let marketItem;

before(async () => {
    marketItem = await MarketItemMain.deployed();
});

contract("Market Item Main Test ", function (accounts) {

    it("Try to create market item", async () => {
        var nftContract = accounts[3];
        var tokenIds = [1,2];
        var price = 10;
        var amounts = [1];
        assert.apply(marketItem._createMarketItem,[nftContract, tokenIds, price, amounts]);
    });

    it("Check if event emitted", async () => {
        var nftContract = accounts[3];
        var tokenIds = [1,2];
        var price = 10;
        var amounts = [1];
        assert.apply(marketItem._createMarketItem,[nftContract, tokenIds, price, amounts]);
    });
});