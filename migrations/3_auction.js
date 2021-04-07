const Auction=artifacts.require("Auction");
const ERC20=artifacts.require("Standard_Token.sol");

module.exports = function (deployer) {
    deployer.deploy(Auction,ERC20.address);
};