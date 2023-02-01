// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BlockDrive{
    /**
    * stores access status of user
    */ 
    struct Access {
        address user;
        bool access; //true or false
    }

    /**
    * mapping value stores the urls stores by particular address
    *value[address1]=> ['url1','url2',...,'urls(n)']
    * n number of images can be uploaded by address1
    */
    mapping(address=>string[]) value;

     /**
    * mapping ownership stores the status of addresses is access by the address 
    * ownership[address1][address2] => true 
    */
    mapping(address=>mapping(address=>bool)) ownership;


     /**
    * mapping accessList stores the list of address accessed by the address
    * so user can be tracked from repeation
    */
    mapping(address=>Access[]) accessList;

    mapping(address=>mapping(address=>bool)) previousState;


    function addUrl(string memory url) external {
        value[msg.sender].push(url); // push image url to ipfs
    }


    function allowance(address _user) external{
        ownership[msg.sender][_user]=true;  // access status true to user "allow user to get access"

        if(previousState[msg.sender][_user]){
            for(uint i=0; i<accessList[msg.sender].length; i++){
                if(accessList[msg.sender][i].user == _user){
                    accessList[msg.sender][i].access=true; // changeing the status of the user instead pushing again
                }
            }
        }else {
            accessList[msg.sender].push(Access(_user,true));  // user status is store in accessList 
        }
    }


    function disAllowance(address _user) public {
        ownership[msg.sender][_user]=false; // disallow user from accessing your data
        
        // search and change the status of allowance to false
        for(uint i=0; i<accessList[msg.sender].length; i++){
            if(accessList[msg.sender][i].user == _user){
                accessList[msg.sender][i].access = false; // user status updated to false is store in accessList 
            }
        }
    }

    
    function display( address _user) external view returns (string[] memory){
        require(_user==msg.sender || ownership[_user][msg.sender], "you don't have access");
        return value[_user];
    }


    function shareAccess() public view returns(Access[] memory){
        return  accessList[msg.sender]; 
    }
}
