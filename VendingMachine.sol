// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.9;

contract VendingMachine{
     address payable owner;

     mapping (address => uint256) public pancake;

     modifier onlyOwner{
          require(msg.sender == owner);
          _;
     }

     constructor(){
          owner=payable(msg.sender);
          pancake[address(this)] = 150; // address(this) => address of the contract stores the amount of the pancake
     }

     function purchase(uint amount) public payable {
          require(msg.value > 1 ether,"Must pay more than 1 ether");
          // require((msg.sender).balance > msg.value , "Insufficient balance");
          require(pancake[address(this)] >= amount ,"Pancakes not in enough stocks");

          pancake[address(this)] -= amount;  
          pancake[msg.sender] += amount;
     }

     function refill(uint amount) public onlyOwner{
          require(pancake[address(this)] < 150 ,"Sufficient stock");

          pancake[address(this)] += amount;
     }

     function withdraw(uint amount) public onlyOwner{
          amount*10**18;  // amount in ethers
          owner.transfer(amount); // transfers ethers to owners address
     }
}



// OTHER FUNCTIONALITIES 
// add more different items like(coffee, cupcake, juice cans, chocolate) etc...
// function to check balance of contract 
// timestamp on refilling 
// pause function and resume function (break time);
// ... and many more functions