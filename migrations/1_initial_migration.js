const Migrations = artifacts.require("Migrations");
const Main = artifacts.require("Main");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Main);
};
