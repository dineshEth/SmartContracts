// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Transaction {
     uint256 transactionCount;

     event Transfer(address from, address reciver, uint amount, string message, uint256 timestamp,string keyword);

     struct TransferStruct{
          address sender;
          address receiver;
          uint amount;
          string message;
          uint256 timestamp;
          string keyword;
     }

     TransferStruct[] transactions;
     
     function addToBlockchain(address payable _reciver,uint _amount, string memory _message ,string memory _keyword) public {

          transactionCount += 1;
          transactions.push(TransferStruct(msg.sender,_reciver,_amount,_message,block.timestamp,_keyword));

          emit Transfer(msg.sender,_reciver,_amount,_message,block.timestamp,_keyword);
     }

     function getAllTransactions() public view returns(TransferStruct[] memory) {
          return transactions;
     }

     function getTransactionCount() public view returns(uint256){
          return transactionCount;
     }

}

