// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    // Data type  stores the information about the capmaign
    struct Campaign{
        address owner; // address of campaign creator
        string title;  // campaign title 
        string description; // campaign description (about campaign 50-250 words)
        uint256 target; // targetAmount to achive
        uint256 deadline; // campaign end date
        uint256 amountColleccted; // total amount the campaign receive
        string image;  // url of the image uploaded on IPFS
        address[] donators; // address of the numbers 
        uint256[] donations; // amount donated by each doner
    }

    // keep track on number of campaignes created :mapping
    mapping(uint256 => Campaign) public campaigns; 

    uint256 public numberOfCampaigns = 0;

    /**create campaign to raise fund  and the function retruns ID of the campaign*/
    function createCampaign
        (
            address _owner,
            string memory _title,
            string memory _description,
            uint256 _target,
            uint256 _deadline,
            string memory _image   
        )
     public  returns(uint256){
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // is everything okay?
        require(campaign.deadline < block.timestamp, "The deadline shouble be a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountColleccted = 0;
        campaign.image = _image;

        // increment of campaign
        numberOfCampaigns ++;

       return  numberOfCampaigns - 1;

    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);
        /** 
            ===>sending ethers using transfer function

             payable(campaign.owner).transfer(msg.value);
             campaign.amountColleccted = campaign.amountColleccted + amount;
        */

        (bool sent,) =  payable(campaign.owner).call{value:amount}("");
        if (sent){
            campaign.amountColleccted = campaign.amountColleccted + amount;
        }
    }

    //returns the list of doantors
    function getDonators (uint256 _id) public view returns(address[] memory, uint256[] memory){
        /**
        * returns two arrays of donators and donation of the campaigns by id
        */
        return (campaigns[_id].donators, campaigns[_id].donations);

    }

    // rerurns the list if camapaigs
    function getCampaigns() public  view returns(Campaign[] memory){ 
        /**
        * creating a new new empty array of multiple campaign strcut
        * an empty array of elements equals to the numberOfCampaigns
        */
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i < numberOfCampaigns; i++){
            //gets the campaign of the id
            Campaign storage item = campaigns[i];

            //pushes the item at index to the allCampaign array
            allCampaigns[i] = item;
        }
        return allCampaigns;
    }
}