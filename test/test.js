const Auction = artifacts.require("Auction.sol");
const ERC20 = artifacts.require("Standard_Token.sol");

contract("2nd MetaCoin test", async accounts => {

    
    it("Function: newItem ", async() => {
        let Erc20 = await ERC20.deployed();
        let instance = await Auction.deployed();
        await instance.NewItem("book",10,100,1617761448,3000,{from:accounts[1]});
       
    })


    it("Function: getItem ", async() => {
        let Erc20 = await ERC20.deployed();
        let instance = await Auction.deployed();
        let name=await instance.name.call();
        let price = await instance.price.call();
        let highestPrice = await instance.highestPrice.call();
        let startTime = await instance.startTime.call();
        let conTime = await instance.conTime.call();
        let isEnd = await instance.isEnd.call();
        let seller = await instance.seller.call();
        let finalPrice = await instance.finalPrice.call();
        let finalBuyer = await instance.finalBuyer.call();
        let Address = await instance.contractAddress.call();
        console.log("name:"+name);
        console.log("price:"+price.toNumber());
        console.log("highestPrice:"+highestPrice.toNumber());
        console.log("stratTime:"+startTime.toNumber());
        console.log("conTime:"+conTime.toNumber());
        console.log("isEnd:"+isEnd);
        console.log("seller:"+seller);
        console.log("finalPrice:"+finalPrice.toNumber());
        console.log("finalBuyer:"+finalBuyer);
        console.log("Address:"+accounts[1]);
        console.log("auctionAddress:"+instance.address);
    })


    it("Function: Bid", async () => {
        let Erc20 = await ERC20.deployed();
        let auction = await Auction.deployed();

        await Erc20.transfer(accounts[2],1000);
        await Erc20.transfer(auction.address,10);

        let num2 =await Erc20.balanceOf(accounts[2]);
        console.log("出价账户初始资产："+num2.toNumber());

        await Erc20.approve(auction.address,205,{from:accounts[2]});

        let num =await Erc20.balanceOf(auction.address);
        console.log("合约资产："+num.toNumber());

        console.log("出价者出价：20");
        await auction.Bid(20,{from:accounts[2]});
        

        
         
    })


    it("Function: End", async() => {
        let erc20 = await ERC20.deployed();
        let auction = await Auction.deployed();

        let mon = await erc20.balanceOf(accounts[2]);
        console.log("出价后，出价者的资产："+mon.toNumber());
        
        let mon2 = await erc20.balanceOf(auction.address);
        console.log("出价后，合约的资产："+mon2.toNumber());
        
        await auction.Stop({from:accounts[1]});

        let mini =await erc20.balanceOf(accounts[1]);
        console.log("拍卖结束后，卖家的资产："+mini.toNumber());
        let num =await erc20.balanceOf(auction.address);
        console.log("拍卖结束后，合约的资产："+num.toNumber());
        
    })

  });