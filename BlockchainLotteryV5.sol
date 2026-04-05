// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BlockchainLotteryV5 is Ownable {
    address[] public participants;
    uint256 public lotteryPool;
    address public winner;
    bool public lotteryEnded;

    event ParticipantJoined(address user, uint256 amount);
    event WinnerDrawn(address winner, uint256 prize);

    constructor() Ownable(msg.sender) {}

    // 参与抽奖
    function joinLottery() external payable {
        require(msg.value == 0.01 ether, "Invalid Ticket Price");
        require(!lotteryEnded, "Lottery Ended");
        participants.push(msg.sender);
        lotteryPool += msg.value;
        emit ParticipantJoined(msg.sender, msg.value);
    }

    // 随机抽取赢家
    function drawWinner() external onlyOwner {
        require(participants.length > 0, "No Participants");
        require(!lotteryEnded, "Already Drawn");
        uint256 index = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % participants.length;
        winner = participants[index];
        payable(winner).transfer(lotteryPool);
        lotteryEnded = true;
        emit WinnerDrawn(winner, lotteryPool);
    }
}
