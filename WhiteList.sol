// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

contract WhiteList{
     uint8 maxWhitlistedAddresses; // max addressescan be white listed
     uint8 numOfWhiteListAddresses; // number of whitelisted initially equals to 0

     address onwer;

     mapping(address => bool ) whitelistAddress;  // addreess which are white listed


     // modidifier 
     modifier onlyOnwer (){
          require(msg.sender==onwer);
          _;
     }

     constructor (uint8 _maxWhiteListAddresses) {
          maxWhitlistedAddresses = _maxWhiteListAddresses;
          onwer = msg.sender;
     }

     function whiteList() public {
          require(!whitelistAddress[msg.sender], "Already whitelisted address");
          require(numOfWhiteListAddresses < maxWhitlistedAddresses, "MOre address can't be whitelist, limit reached");
          whitelistAddress[msg.sender] = true;  // whitelist true
          numOfWhiteListAddresses++; // increment
     }

     function increseWhitelistaddres(uint8 _moreAddress) public onlyOnwer {
          // only onwer (deployer of the smart contract) can call the funciton and increment
          maxWhitlistedAddresses += _moreAddress; // more address can be whitelisted 
     }
}

// OTHER FUNCTIONALITIES 
// owner can remove address from white listed in such case
// onwer can also white list address if need