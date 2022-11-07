const MarketPlaceMain1155 = artifacts.require("MarketPlaceMain1155");

let marketPlace;

before(async () => {
    marketPlace = await MarketPlaceMain1155.new();
});

contract('Market Place Tests', function(accounts) {
    it("is has a manager_address equal to deployer_address", async () => {
        var manager_address = await marketPlace.manager.call();
        var deployer_address = accounts[0];
        assert.equal(manager_address, deployer_address, "manager is not deployer");

    });
});