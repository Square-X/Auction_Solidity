const Migrations = artifacts.require("Migrations");
//const Auction=artifacts.require("Auction");
//const ERC20=artifacts.require("Standard_Token.sol");

module.exports = function (deployer,network,accounts) {

    deployer.deploy(Migrations);
   // await deployer.deploy(ERC20,1000,"a",18,"USD");
   // await deployer.deploy(Auction,1000,10000,200,ERC20.address);
  
};
