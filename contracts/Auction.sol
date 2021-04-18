// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Standard_Token.sol";

contract Auction {
    Standard_Token public ERC20;

    event buyerPrint(address buyer , uint lowestPrice);
    event auctionStop(string message);
    address payable public contractAddress=payable(address(this));
    uint public Count;
    
    constructor(Standard_Token token) public {
        ERC20=token;
    }
    //商品信息
        string public name;                //商品名
        uint256 public lowestPrice;              //底价
        uint256 public expectedPrice;       //最高期望价格
        uint256 public startTime;          //商品开始拍卖时间
        uint256 public conTime;            //拍卖持续时间
        bool public isEnd;                 //拍卖停止标志  结束为true  开始为false
        address public seller;              //卖家

        uint256 public highestPrice;         //当前最高价
        address public finalBuyer;         //当前最高价买家
        
    mapping(address => uint) public buyerList;      //Buyer to lowestPrice
    address[] public listKey;
    
    
    //新商品上架
    function NewItem(string memory _name,uint _price,uint _expectedPrice,uint _startTime,uint _conTime) public {
        if(seller==address(0) || (seller != address(0) && isEnd==true))
        {
            name = _name;
            lowestPrice = _price;
            expectedPrice = _expectedPrice;
            startTime = _startTime;
            conTime = _conTime;
            isEnd = false;                       //停止标志默认为false
            seller = msg.sender;                 //卖家地址为函数调用用户地址
            highestPrice = 0;
            Count=0;
        }
        else
        {
            revert("The auction is not over yet");
        }
       
    }
    
    
    //获取商品信息
    function GetItem() public returns(string memory _name,uint _lowestprice,uint _expectedPrice,uint _startTime,uint _conTime,bool _isEnd,address _seller,uint _highestPrice,address _finalBuyer){
     
        return(name,lowestPrice,expectedPrice,startTime,conTime,isEnd,seller,highestPrice,finalBuyer);
    }
    
    
    //卖家主动终止拍卖
    function Stop() public {
        require(seller==msg.sender,"You are not the seller of this item");
       // require(isEnd == false);
        AuctionEnd();
    }
    
    
    //卖家在有人出价之前更改底价
    function changeMinimum(uint _change) public {
        require(seller == msg.sender , "You are not the seller of this item");
        require(highestPrice == 0 , "Auction has started");
        lowestPrice = _change;
    }
    
    
    //买家出价
    function Bid(uint value)  public payable {
        
        require(block.timestamp<startTime+conTime,"Bidding time is over");      
       
        require(isEnd != true,"The Auction is over");
        
        require(value+buyerList[msg.sender] >= lowestPrice, "The lowestPrice is below the minimum lowestPrice");        //第一次出价不得低于底价
        require(value+buyerList[msg.sender] >= highestPrice, ""); 

        ERC20.transferFrom(msg.sender, address(this), value);
        if(buyerList[msg.sender]==0)
        {
            
            listKey.push(msg.sender);
            //buyerList[msg.sender]=value;
            Count++;
        }
        buyerList[msg.sender]+=value;
        highestPrice=buyerList[msg.sender];
        finalBuyer=msg.sender;

        
        
        if(buyerList[msg.sender]>=expectedPrice)
        {
            AuctionEnd();
        }     
    }
    
    
    //获取出价者地址和出价
    // function getBuyerList() view public{
        
    //     for(uint i = 0; i < listKey.length; i++)
    //     {
    //         emit buyerPrint(listKey[i] , buyerList[listKey[i]]);
    //     }
    // }
    
    
    //拍卖结束
    function AuctionEnd() public payable{
       // require(isEnd == false,"The Auction is over");
        isEnd=true;
        if(highestPrice != 0)
        {
           
          ERC20.transfer(seller,highestPrice);
          highestPrice=0;
          buyerList[finalBuyer]=0;
        }
    }
    

    function withDraw() public payable{
        require(isEnd==true,"The auction is not over yet");
        require(buyerList[msg.sender] > 0);
        ERC20.transfer(msg.sender, buyerList[msg.sender]);
        buyerList[msg.sender]=0;
    }
   // function () {revert();}  
}