// SPDX-License-Identifier: MIT

interface IERC{
     function transferFrom(
          address sender,
          address to,
          uint256 id
     ) external;
}

contract DutchAuction{

     uint256 public DURATION = 7 days; // duration of dutch auction

     // creates the nft instance 
     IERC public nft; 
     uint256 public nftId; // nft token id

     address payable public immutable seller;
     uint public immutable startAt;
     uint public immutable endAt;
     uint public immutable startPrice;
     uint public immutable discountRate;


     constructor(
          address _nft,
          uint _nftId,
          uint _startPrice,
          uint _discountRate
     ) {
          seller = payable(msg.sender);
          startAt = block.timestamp;
          endAt = block.timestamp + DURATION;
          startPrice = _startPrice;
          discountRate = _discountRate;

          nft = IERC(_nft); //  address of the existing nft address
          nftId = _nftId; // nftId of the existing nft
     }

     function getPrice() public view returns(uint256){
          uint timeElapsed =  block.timestamp - startAt;  // total time passed
          uint discountprice = discountRate * timeElapsed;  // the discount price depends the time passed
          return startPrice -  discountprice; // the price is decreased at every time
     }

     function buy() public payable {
          uint price =  getPrice(); // get the current price of the auction 
          require(msg.value >=  price , "PRICE IS LESS THE AUCTION PRICE");
          require(endAt > block.timestamp, "AUCTION IS ENDED");

          nft.transferFrom(seller,msg.sender,nftId);  // transfer the nft to the client

          uint refund =  msg.value - price; // refund of the client 
          if(refund > 0){
               payable(msg.sender).transfer(refund);
          }
          selfdestruct(seller);
     }

    
}



// IN Dutch Auction the price of the auction decreses by the time
// first one takes the nft 