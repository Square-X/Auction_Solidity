// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Standard_Token.sol";

contract Auction {
    Standard_Token public ERC20;

    event buyerPrint(address buyer , uint price);
    event auctionStop(string message);
    address payable public contractAddress=payable(address(this));
    uint public Count;
    
    constructor(Standard_Token token) public {
        ERC20=token;
    }
    //商品信息
        string public name;                //商品名
        uint256 public price;              //底价
        uint256 public highestPrice;       //最高期望价格
        uint256 public startTime;          //商品开始拍卖时间
        uint256 public conTime;            //拍卖持续时间
        bool public isEnd;                 //拍卖停止标志  结束为true  开始为false
        address public seller;      //卖家

        uint256 public finalPrice;         //当前最高价
        address public finalBuyer;         //当前最高价买家
        
    mapping(address => uint) public buyerList;
    address[] public listKey;
    
    
    //新商品上架
    function NewItem(string memory _name,uint _price,uint _highestPrice,uint _startTime,uint _conTime) public {
        name = _name;
        price = _price;
        highestPrice = _highestPrice;
        startTime = _startTime;
        conTime = _conTime;
        isEnd = false;                       //停止标志默认为false
        seller = msg.sender;                 //卖家地址为函数调用用户地址
        finalPrice = 0;
        Count=0;
    }
    
    
    //获取商品信息
    function GetItem() public returns(string memory _name,uint _price,uint _highestPrice,uint _startTime,uint _conTime,bool _isEnd,address _seller,uint _finalPrice,address _finalBuyer){
     
        return(name,price,highestPrice,startTime,conTime,isEnd,seller,finalPrice,finalBuyer);
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
        require(finalPrice == 0 , "Auction has started");
        price = _change;
    }
    
    
    //买家出价
    function Bid(uint value)  public payable {
        
        require(block.timestamp<startTime+conTime,"Bidding time is over");      
       
        require(isEnd != true,"The Auction is over");
        
        //ERC20.transferFrom(msg.sender,contractAddress, value);   
        ERC20.transferFrom(msg.sender, address(this), value);
        if(buyerList[msg.sender]==0)
        {
            require(value >= price, "The price is below the minimum price");        //第一次出价不得低于底价
            listKey.push(msg.sender);
            buyerList[msg.sender]=value;
            Count++;
        }
        else
        {
            buyerList[msg.sender]+=value;
        }
        
        if(buyerList[msg.sender]>=highestPrice)
        {
            finalPrice=buyerList[msg.sender];
            finalBuyer=msg.sender;
            AuctionEnd();
        }
        else
        {
             if(buyerList[msg.sender]>finalPrice)
             {
                 finalPrice=buyerList[msg.sender];
                 finalBuyer=msg.sender;
             }
        }
        
    }
    
    
    //获取出价者地址和出价
    function getBuyerList() public{
        
        for(uint i = 0; i < listKey.length; i++)
        {
            emit buyerPrint(listKey[i] , buyerList[listKey[i]]);
        }
    }
    
    
    //拍卖结束
    function AuctionEnd() public payable{
       // require(isEnd == false,"The Auction is over");
        isEnd=true;
        if(finalPrice != 0)
        {
            for(uint i = 0 ; i < Count ; i++)
            {
                if(listKey[i] != finalBuyer)
                {
                    //listKey[i].transfer(buyerList[listKey[i]]);
                    ERC20.transfer(listKey[i],buyerList[listKey[i]]);
                    listKey[i]=address(0);
                    buyerList[listKey[i]]=0;
                }
            }
            
          //  seller.transfer(finalPrice);
          ERC20.transfer(seller,finalPrice);
          finalBuyer=address(0);
          finalPrice=0;
        }
    }
    
   // function () {revert();}  
}