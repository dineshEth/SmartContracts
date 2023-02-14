// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Elections {

     struct Candidate{
          uint8 id;
          address identity;
          string name;
          string details;
          uint256 voteCount;
          string electionId;
     }

     uint8 public candidateCount;  // counting of candidates
 
     mapping (uint8 => Candidate) public candidates;  // all the different candidates data
     mapping (address => bool) public candidate; // all the exiting candidates' addrees and status
     mapping (address => bool) public voters; // voters

     constructor () {}

     event VoteEvent(uint indexed _candidate);

     function addCandidate(
          string memory _name,
          string memory _details,
          string memory _electionId
     ) public {
          require(!candidate[msg.sender],"Already existing candidate");

          candidateCount++; 
          // candidated registered
          candidates[candidateCount] = Candidate(
               candidateCount,
               msg.sender,
               _name,
               _details,
               0,
               _electionId
          );
          candidate[msg.sender] = true;  // you,re a candidate
     }


     function vote(uint8 _candidateId) public {
          require(!voters[msg.sender], "Already voted");
          require(_candidateId > 0 && _candidateId <= candidateCount, "NO such candidate exits");
          require(candidateCount > 0 ,"No candidate yet to vote");

          voters[msg.sender] = true;  // voted true 
          candidates[_candidateId].voteCount += 1;  // vote increased by 1 for the candidate

          emit VoteEvent(_candidateId);
     }
}

// OTHER FUNCTIONALITIES CAN BE ADDEDED SUCH AS 
// time period 
// candidate cannot vote
// limit for candidates
// approval of candidate by owner of the deployer after registrations
// winner of the contest or election
// ....and many more