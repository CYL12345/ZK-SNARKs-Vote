//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract DaoVote{
    mapping (address => bool) public hasVoted;
    uint256 public yesCount;
    uint256 public noCount;

    event Voted(address indexed voter, bool choice);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function vote(bool choice) external {
        require(!hasVoted[msg.sender],"Already voted");
        hasVoted[msg.sender] = true;
        if(choice){
            yesCount++;
        }
        else{
            noCount++;
        }
        emit Voted(msg.sender, choice);
    }

    function getResult() external view returns(uint256 yes,uint256 no){
        return (yesCount,noCount);
    }
}