// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract BlockchainVoting {
    struct Vote {
        string candidate;
        uint256 count;
    }

    Vote[] public votes;
    mapping(address => bool) public hasVoted;

    event VoteCast(address voter, string candidate);

    constructor(string[] memory candidates) {
        for (uint256 i = 0; i < candidates.length; i++) {
            votes.push(Vote({candidate: candidates[i], count: 0}));
        }
    }

    function vote(uint256 candidateIndex) external {
        require(!hasVoted[msg.sender], "Already Voted");
        hasVoted[msg.sender] = true;
        votes[candidateIndex].count++;
        emit VoteCast(msg.sender, votes[candidateIndex].candidate);
    }
}
