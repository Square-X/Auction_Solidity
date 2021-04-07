const ERC20 = artifacts.require("Standard_Token.sol");

module.exports = function (deployer) {
    
  deployer.deploy(ERC20,10000,"a",18,"USD");
  
};