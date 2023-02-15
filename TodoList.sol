// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Todos {
     struct Todo {
          string text;
          bool completed;
          uint256 timestamp;
     }

     Todo[] public todos;

     function createTodo(string memory text) public {
          todos.push(Todo(text,false,block.timestamp));

          /** 
               todo.push(Todo(
                    {
                         text:text,
                         completed: false,
                         timestamp:block.timestamp
                    }
               ));
          */
     }

     
     function getTodo(uint index) public view returns( string memory text,bool completed){
          // memory  : copies the data, and change only in the copied data
          // storage : do not copies the data, instead saves the address and changes to the original data

          Todo storage todo = todos[index];  // todo saves the address of todos instead of copying
          return (todo.text ,todo.completed); // returns the original data as it saves the address
     }


     function updateTodoText(uint index, string calldata text) public {
          Todo storage todo = todos[index]; 
          // remember this do not copy the data
          todo.text = text;  // changes int the original data at the index
     }

     function toggleCompete(uint index) public {
          Todo storage todo = todos[index];
          todo.completed = !todo.completed;
     }
} 

// OTHER FUNCTIONALITIES 
// delete todo 
// title, details, deadline , priority etc.. properties can also be implemented
// ... and meny more