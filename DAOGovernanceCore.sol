// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOGovernanceCore is Ownable {
    struct Proposal {
        string description;
        uint256 voteFor;
        uint256 voteAgainst;
        uint256 endTime;
        bool executed;
    }

    uint256 public proposalCounter;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 id, string desc, uint256 endTime);
    event VoteCast(uint256 id, address voter, bool support);

    constructor() Ownable(msg.sender) {
        proposalCounter = 0;
    }

    // 创建DAO提案
    function createProposal(string calldata description, uint256 duration) external onlyOwner {
        uint256 endTime = block.timestamp + duration;
        proposals[proposalCounter] = Proposal({
            description: description,
            voteFor: 0,
            voteAgainst: 0,
            endTime: endTime,
            executed: false
        });
        emit ProposalCreated(proposalCounter, description, endTime);
        proposalCounter++;
    }

    // 投票
    function castVote(uint256 proposalId, bool support) external {
        Proposal storage prop = proposals[proposalId];
        require(block.timestamp < prop.endTime, "Voting Ended");
        require(!hasVoted[msg.sender][proposalId], "Already Voted");

        hasVoted[msg.sender][proposalId] = true;
        if (support) prop.voteFor++;
        else prop.voteAgainst++;
        emit VoteCast(proposalId, msg.sender, support);
    }
}
