// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// neeed to install openzeppelin 
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract NFT is ERC721 {

     uint256 tokenId;

     constructor(string name, string symbol) ERC721(name,symbol){}

     function mint(
          uint256 _tokenId,
          address _recipient,
          string _tokenURI
     ) public onlyOwner retruns (uint256) {
          tokenId = _tokenId;
          _mint(_recipient,tokenId);  // mint the nft to the id
          _setTokenURI(tokenId,_tokenURI);  // set the token url to the nft id

          return tokenId;
     }
}


// step to follow
// deploy nft smart contract and mint the nft
// copy nft contract and pass the nft contract to the DutchAuction smart contract where your created the instance of the nft

// copy the DucthAuction smart contract address and approve the nft to the contract to start the auction