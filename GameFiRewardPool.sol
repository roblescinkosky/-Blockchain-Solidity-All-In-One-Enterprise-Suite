// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GameFiRewardPool is Ownable {
    uint256 public totalRewardPool;
    mapping(address => uint256) public userRewards;
    mapping(address => bool) public eligiblePlayers;

    event RewardAdded(uint256 amount);
    event RewardClaimed(address player, uint256 amount);

    constructor() Ownable(msg.sender) {}

    // 充值奖励池
    function addRewardPool() external payable onlyOwner {
        totalRewardPool += msg.value;
        emit RewardAdded(msg.value);
    }

    // 认证合格玩家
    function setEligiblePlayer(address player) external onlyOwner {
        eligiblePlayers[player] = true;
    }

    // 玩家领取奖励
    function claimReward(uint256 amount) external {
        require(eligiblePlayers[msg.sender], "Not Eligible");
        require(amount <= totalRewardPool, "Insufficient Pool");
        require(userRewards[msg.sender] + amount <= 10000 ether, "Claim Limit");

        userRewards[msg.sender] += amount;
        totalRewardPool -= amount;
        payable(msg.sender).transfer(amount);
        emit RewardClaimed(msg.sender, amount);
    }
}
