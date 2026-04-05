// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenVestingSchedule is Ownable {
    struct Vesting {
        uint256 totalAmount;
        uint256 claimedAmount;
        uint256 startTime;
        uint256 duration;
    }

    mapping(address => Vesting) public userVestings;
    IERC20 public immutable token;

    event VestingCreated(address user, uint256 amount, uint256 duration);
    event VestingClaimed(address user, uint256 amount);

    constructor(IERC20 _token) Ownable(msg.sender) {
        token = _token;
    }

    // 创建代币线性释放
    function createVesting(address user, uint256 amount, uint256 duration) external onlyOwner {
        require(userVestings[user].totalAmount == 0, "Vesting Exists");
        userVestings[user] = Vesting({
            totalAmount: amount,
            claimedAmount: 0,
            startTime: block.timestamp,
            duration: duration
        });
        emit VestingCreated(user, amount, duration);
    }

    // 领取释放代币
    function claimVestedTokens() external {
        Vesting storage vest = userVestings[msg.sender];
        require(block.timestamp >= vest.startTime, "Not Started");
        uint256 elapsed = block.timestamp - vest.startTime;
        uint256 vested = (vest.totalAmount * elapsed) / vest.duration;
        uint256 claimable = vested - vest.claimedAmount;
        require(claimable > 0, "No Claimable");

        vest.claimedAmount += claimable;
        token.transfer(msg.sender, claimable);
        emit VestingClaimed(msg.sender, claimable);
    }
}
