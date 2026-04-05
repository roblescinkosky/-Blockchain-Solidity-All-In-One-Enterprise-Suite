// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WhitelistContract is Ownable {
    mapping(address => bool) public whitelist;
    uint256 public whitelistLimit;

    event Whitelisted(address user);

    constructor() Ownable(msg.sender) {
        whitelistLimit = 1000;
    }

    // 添加白名单
    function addToWhitelist(address user) external onlyOwner {
        require(!whitelist[user], "Already Whitelisted");
        whitelist[user] = true;
        emit Whitelisted(user);
    }

    // 批量添加白名单
    function batchWhitelist(address[] calldata users) external onlyOwner {
        for (uint256 i = 0; i < users.length; i++) {
            whitelist[users[i]] = true;
        }
    }
}
