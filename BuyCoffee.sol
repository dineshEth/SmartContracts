// SPDX-License-Identifier: MIT 

/**version of the solidity compiler */
pragma solidity ^0.8.0;

contract BuyCoffee{

     //buyer information object
     struct CoffeeBuyer{
          address account;
          string name;
          string message;
          uint256 amount;
          uint256 timestamp;
     }
     
     // owner payable 
     address payable owner;
     constructor(){
          owner = payable(msg.sender); // contract deployer is owner
     }

     //array of buyers
     CoffeeBuyer[] buyers;

    //function send ethers to onwer account to buy coffee
     function buyCoffee(string memory _name, string memory _message, uint256 _amount) public  payable{
          require(_amount > 0 ,"Send a sufficient amount"); 
          owner.transfer(_amount);  // transfers to onwer account

          buyers.push(
               CoffeeBuyer(msg.sender, _name, _message,_amount, block.timestamp)
          ); 
          // data push to an array
     }

     function getBuyers() public view returns(CoffeeBuyer[] memory){
          return buyers; // returns buyers array
     }
}
