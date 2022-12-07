//const LinkToken = artifacts.require("LinkToken");

const LinkToken = artifacts.require("ERC20");
console.log(LinkToken);
// set provider for all later instances to use
//Contract.setProvider("ws://localhost:8546");
const payment = "100000000000000000"; // 0.1 LINK

async function fundContractWithLink(contractAddress) {
  let linkToken;
  //try erc ERC20oken
  linkToken = await LinkToken.at("0x326C977E6efc84E512bB9C30f76E30c160eD06FB");

  try {
    const tx = await linkToken.transfer(contractAddress, payment);
    console.log("Contract funded with Link");
  } catch (e) {
    console.log(e);
    console.log(
      "Looks like there was an issue! Make sure you have enough LINK in your wallet!"
    );
  }
}

module.exports = {
  fundContractWithLink,
};
