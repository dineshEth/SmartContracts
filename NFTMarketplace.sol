// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/** install  openzeppelin contracts
 * npm install @openzeppelin/contracts
 */
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract NFTMarketplace is ERC721URIStorage {
     address payable public owner;

     using Counters for Counters.Counter;
     Counters.Counter private tokenIds;
     Counters.Counter private soldTokens;

     uint256 public listingPrice = 0.02 ether;

     constructor() ERC721("Marketplace","MNFT"){
          owner  = payable(msg.sender);
     }

     struct Token {
          uint256 tokenId;
          address owner;
          address seller;
          uint price;
          bool listed;
          bool sold;
     }

     mapping (uint256 => Token) private listedTokens;

     function updatePrice(uint256 price) public {
          require(owner == msg.sender, "Only Owner can update");
          listingPrice = price;
     }

     function getTokenPrice(uint256 tokenId) public view returns (uint256){
          require(listedTokens[tokenId].listed ,"Token not listed yet");

          uint256 currentPrice = listedTokens[tokenId].price;
          return currentPrice;
     }

     function getLetestTokenId() public view returns (uint256){
          uint256 currentTokenId = tokenIds.current();
          return currentTokenId;
     }

     function getTokenForId(uint256 tokenId) public view returns (Token memory){
          require(listedTokens[tokenId].listed ,"Token not listed yet");
          
          return listedTokens[tokenId];
     }

     function getLetestToken() public view returns (Token memory){
          uint256 currentTokenId = tokenIds.current();
          return listedTokens[currentTokenId];
     }


     function createToken(string memory tokenURI, uint256 price) public payable returns (uint256){
          require(msg.value == listingPrice,"Invalid listing price");
          require(price > 0,"Invalid price of the token");

          tokenIds.increment();
          uint256 tokenId = tokenIds.current();

          _safeMint(msg.sender, tokenId);
          _setTokenURI(tokenId, tokenURI);

          createListToken(tokenId, price);

          return tokenId;
     }

     function createListToken(uint256 tokenId, uint256 price) public {
          listedTokens[tokenId] = Token(
               tokenId,
               payable(address(this)),
               payable(msg.sender),
               price,
               true,
               false
          );

          _transfer(msg.sender, address(this), tokenId);
     }

     function getAllNFTs() public view returns(Token[] memory){
          uint256 nftCounts = tokenIds.current();

          Token[] memory NFTs= new Token[](nftCounts);

          uint index = 0;
          for(uint i=0;i<nftCounts;i++){
               uint id = i+1;

               Token storage currentToken = listedTokens[id];
               NFTs[index] = currentToken;

               index += 1;
          }
          return NFTs;
     }

     function getMyNFTs() public view returns(Token[] memory){
          uint nftsCount = tokenIds.current();

          uint myNftsCount = 0;
          for(uint i=0; i<nftsCount; i++){
               if(listedTokens[i+1].owner == msg.sender || listedTokens[i+1].seller == msg.sender){
                    myNftsCount += 1;
               }
          }

          Token[] memory myNFTs = new Token[](myNftsCount);

          uint index = 0;
          for(uint i=0; i<nftsCount; i++){
               if(listedTokens[i+1].owner == msg.sender || listedTokens[i+1].seller == msg.sender){
                    uint id = i + 1;

                    Token storage currentToken = listedTokens[id];
                    myNFTs[index] = currentToken;

                    index += 1;
               }
          }
          return myNFTs; 
     }

     function executeSale(uint256 tokenId) public payable {

          uint price = listedTokens[tokenId].price;
          address seller  = listedTokens[tokenId].seller;

          require(msg.value == price ,"Invalid amount, cannot by NFT");

          listedTokens[tokenId].seller = payable(msg.sender);
          listedTokens[tokenId].sold = true;

          soldTokens.increment();

          _transfer(address(this),msg.sender,tokenId);

          payable(seller).transfer(msg.value);
          payable(owner).transfer(listingPrice);

          approve(address(this),tokenId);
     }
}