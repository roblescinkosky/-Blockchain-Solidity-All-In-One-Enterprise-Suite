// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenAirdropTool is Ownable {
    IERC20 public immutable token;
    uint256 public airdropAmount;

    event AirdropSent(address[] recipients, uint256 amountEach);

    constructor(IERC20 _token) Ownable(msg.sender) {
        token = _token;
        airdropAmount = 100 * 10**18;
    }

    // 批量空投
    function batchAirdrop(address[] calldata recipients) external onlyOwner {
        uint256 total = recipients.length * airdropAmount;
        require(token.balanceOf(address(this)) >= total, "Insufficient Balance");
        for (uint256 i = 0; i < recipients.length; i++) {
            token.transfer(recipients[i], airdropAmount);
        }
        emit AirdropSent(recipients, airdropAmount);
    }

    // 设置空投数量
    function setAirdropAmount(uint256 newAmount) external onlyOwner {
        airdropAmount = newAmount;
    }
}
