// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAOVotingPower is Ownable {
    IERC20 public immutable governanceToken;
    mapping(address => uint256) public votingPower;

    event VotingPowerUpdated(address user, uint256 power);

    constructor(IERC20 _token) Ownable(msg.sender) {
        governanceToken = _token;
    }

    // 更新投票权
    function updateVotingPower(address user) external {
        votingPower[user] = governanceToken.balanceOf(user);
        emit VotingPowerUpdated(user, votingPower[user]);
    }
}
