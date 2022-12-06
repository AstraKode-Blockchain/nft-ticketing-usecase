import fetch from "node-fetch";

const GetInfected = artifacts.require("../contracts/GetInfected");
const assert = require("assert");

let getInfected;

contract("1. GetInfected contract test", function (accounts) {
    before(async () => {
        getInfected = await GetInfected.deployed();

        const res = await fetch('https://api.apify.com/v2/key-value-stores/vqnEUe7VtKNMqGqFF/records/LATEST?disableRedirect=true%27');
  
        obj = await res.json();
    });

    it("1.1 Try to get infected parameters from api", async () => {
        var volume = await getInfected.requestVolumeData();
        assert.strictEqual(volume, obj.infectedByRegion[2].infectedCount, ''); 
    });
});