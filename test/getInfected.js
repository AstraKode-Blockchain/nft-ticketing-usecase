//import fetch from "node-fetch";
const Web3 = require("web3");
const assert = require("assert");

// set provider for all later instances to use
const GetInfected = artifacts.require("../contracts/GetInfected");

let web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");

let getInfected;
let obj;
//let linkToken;
contract("1. GetInfected contract test", function (accounts) {
  before(async () => {
    // nftContract = await NFTContract.deployed();
    getInfected = await GetInfected.deployed();
  });
  it("1.1 Try to get infected parameters from api", async () => {
    const res = await fetch(
      "https://api.apify.com/v2/key-value-stores/vqnEUe7VtKNMqGqFF/records/LATEST?disableRedirect=true%27"
    );
    obj = await res.json();
    //console.log(obj);
  });

  it("1.2 Try to get infected parameters from oracle", async () => {
    //linkToken = await LinkToken.at(linkAddress);
    //await fundContractWithLink(getInfected.address);
    // let linkContract = new web3.eth.Contract(abi, linkAddress);
    // let tx = await linkContract.methods.transfer(getInfected.address, payment);
    //console.log("Contract funded with Link");
    //var req = await getInfected.requestVolumeData();
    var volume = await getInfected.volume.call();

    console.log("Volume from api: " + obj.infectedByRegion[2].infectedCount);
    console.log("Volume from oracle: " + volume / 1000000000000000000);
    assert.equal(
      volume / 1000000000000000000,
      parseInt(obj.infectedByRegion[2].infectedCount),
      "error"
    );
  });
});
