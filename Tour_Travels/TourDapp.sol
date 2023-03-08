// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


contract TripTour{
    uint256 tripCount = 0;
    uint256 createTripAmount = 0.025 ether;                                // price to register a new trip
    address payable public owner;                                          // smart contract owner

    uint256 id = 1000;                                                     // id genrator for agencies

    constructor (){
        owner = payable (msg.sender);
    }
                                                                           // agency struct
    struct Agency {
        string name;
        address addr;
        string about;
        uint256 id;
        bool registered;
    }

    mapping(address => Agency) public registeredAgency;                   
    mapping(address => uint256) public tripsCount;                        // trip count for each agency
    mapping(uint256 => address) public agencyAddress;

                                                                          // trips data structure
    struct Trip{
        string agencyName;
        address owner;
        string tripName;
        uint256 price;
        string aboutTrip;
        uint256[2] dates;
        string image;
        string place;
        bytes32 tripcode;
        uint256 bookingCount;
        uint256 totalCount;
    }

    mapping(uint256 => Trip) public trip;                        // all the trips 

                                                                 // user information
    struct User {
        address user;
        uint ticketCount;
        uint tripcode;
        bool confirm;
        uint[] tickets;
    }
                                                                 // travellers mapping
    mapping(address => User) public travellers;

    /** registration fucntion for agency
     * create trip and starts earnings
     * returns id of on confirm registration
     */
    function regiterAgency(
        string memory name,string memory description
        ) public payable returns(uint256) {

            require(!registeredAgency[msg.sender].registered , "You're a registered Agency");

            uint _id = id;
            registeredAgency[msg.sender] = Agency(
                name,msg.sender,description,_id, true
            );

            id++;
            return _id;
    }


    /** creates trip by a agency only */
    function createTrip (
        string memory _tripName,
        uint256 _price,
        string memory _description,
        string memory _image,
        string memory  _place,
        uint256 _total,
        uint dayTrip 
    ) public payable  returns(bytes32){

        require(msg.value == createTripAmount , "Pay suffcient ether to create a trip");
        require(registeredAgency[msg.sender].registered , "Register your agency");
        
        uint256 tripId = tripCount + 1;
        
        string memory _agency = registeredAgency[msg.sender].name;

        /** Generates a cryptography hash for a trip and a uinque code for the trip */
        bytes32 tripcode = keccak256(abi.encode(_tripName)); 
        uint tripDays = dayTrip * 1 days;  // trip durations
       

        trip[tripId]  = Trip(
            _agency,msg.sender,_tripName,_price,_description,
            [block.timestamp, block.timestamp + tripDays],
            _image,_place,tripcode,0,_total
        );

        tripCount += 1;
        tripsCount[msg.sender] += 1;

        payable(address(this)).transfer(createTripAmount);    // amount is strore in contract address
    
    return tripcode;   // retruns a unique trip code 
    }


    /** Book a trip 
     * parameter => count: number of ticktes you buy; id : which trip of the agency you pay for
     */
    function  bookTrip(uint count,uint _id) public payable returns (uint256) {
        require(trip[id].bookingCount < trip[id].totalCount, "Check our different trips");
        require(msg.value * count == trip[_id].price * count, "Pay the actual ticket price");
        require(count < trip[id].totalCount && count > 0 ,"Not availble");

        uint256 ticket = trip[_id].bookingCount;       // availabe bookings
        uint256 price = trip[_id].price * count;       // price * number of tickets  = total aount to be paid
        address tripOwner = trip[_id].owner;           // trip organizer's address 

        User storage user = travellers[msg.sender];      
        
        user.user = msg.sender;
        user.ticketCount = count;
        user.tripcode = 1000 + ticket;                 // tripcode (think of PNR Number)
        user.confirm = true;
        for(uint i=0 ;i<count; i++){
            user.tickets.push(ticket);                 // number of tickets you buy
            ticket++;
        }

        trip[_id].bookingCount += count;    
        
        payable(tripOwner).transfer(price);            // pay to owner of the trip oragnizer

        return user.ticketCount = count;
    }


    /** cancel trip
     * pay 10% penalty
     * delete user from mapping
     * cancel tickets and allot it to others
     * pay 90% back to user
     */
    function cancelBooking(uint _id, uint count) public {
        require(travellers[msg.sender].confirm,"Not confirmed traveller");
        require(trip[id].dates[1] < block.timestamp,"Trip expired");

        uint256 price = trip[_id].price;             // price
        uint256 penaltyCharge = (price * 1)/10;      // penalty 10%
        uint amount = price - penaltyCharge;         // 90%

        delete travellers[msg.sender];               // delete user
        trip[_id].bookingCount -= count;             // free from booking and allot for other
        payable (msg.sender).transfer(amount);       // pay back
    }


    function getAllTrips() external view returns(Trip[] memory){
        uint256 countTrip = tripCount;

        Trip[] memory trips = new Trip[](countTrip);

        uint index = 0;

        for(uint256 i = 0; i < countTrip; i++){
            uint _id = i + 1;
            Trip storage currentItem = trip[_id];
            trips[index] = currentItem;
            index++;
        }

        return trips;
    }

    function allTripForId(uint256 id)external  {

    }

    function getMyTrips() external view returns(Trip[] memory){
        uint256 countTrips = tripCount;

        uint256 myTripsCount = 0;
        for(uint i = 0; i<countTrips;i++){
            if(trip[i+1].owner == msg.sender){
                myTripsCount++;
            } 
        }
        Trip[] memory myTrips = new Trip[](myTripsCount);

        uint index = 0;
        for (uint256 i=0; i<countTrips;i++){
            if(trip[i+1].owner == msg.sender){
                uint256 _id = i + 1;
                Trip storage currentTrip = trip[_id];
                myTrips[index] = currentTrip;
                index++;
            }
        }
        return myTrips;

    }
}