// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

contract WhiteList{
     uint8 maxWhitlistedAddresses; // max addressescan be white listed
     uint8 numOfWhiteListAddresses; // number of whitelisted initially equals to 0

     mapping(address => bool ) whitelistAddress;  // addreess which are white listed

     constructor (uint8 _maxWhiteListAddresses) {
          maxWhitlistedAddresses = _maxWhiteListAddresses;
     }

     function whiteList() public {
          require(!whitelistAddress[msg.sender], "Already whitelisted address");
          require(numOfWhiteListAddresses < maxWhitlistedAddresses, "MOre address can't be whitelist, limit reached");
          whitelistAddress[msg.sender] = true;  // whitelist true
          numOfWhiteListAddresses++; // increment
     }
}