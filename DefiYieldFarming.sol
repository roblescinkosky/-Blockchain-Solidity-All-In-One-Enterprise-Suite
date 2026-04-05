// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DefiYieldFarming is Ownable {
    IERC20 public immutable stakeToken;
    IERC20 public immutable rewardToken;
    uint256 public rewardRate;
    mapping(address => uint256) public userStake;

    event Staked(address user, uint256 amount);
    event RewardHarvested(address user, uint256 amount);

    constructor(IERC20 _stake, IERC20 _reward) Ownable(msg.sender) {
        stakeToken = _stake;
        rewardToken = _reward;
        rewardRate = 10**18;
    }

    // 质押挖矿
    function stake(uint256 amount) external {
        stakeToken.transferFrom(msg.sender, address(this), amount);
        userStake[msg.sender] += amount;
        emit Staked(msg.sender, amount);
    }

    // 收获奖励
    function harvest() external {
        uint256 reward = userStake[msg.sender] * rewardRate;
        rewardToken.transfer(msg.sender, reward);
        emit RewardHarvested(msg.sender, reward);
    }
}
