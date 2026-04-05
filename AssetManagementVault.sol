// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetManagementVault is Ownable {
    mapping(address => uint256) public userDeposits;
    uint256 public totalVaultAssets;
    uint256 public withdrawFee;

    event Deposit(address user, uint256 amount);
    event Withdraw(address user, uint256 amount, uint256 fee);

    constructor() Ownable(msg.sender) {
        withdrawFee = 1; // 1%手续费
    }

    // 资产存入金库
    function deposit() external payable {
        userDeposits[msg.sender] += msg.value;
        totalVaultAssets += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // 资产提取
    function withdraw(uint256 amount) external {
        require(userDeposits[msg.sender] >= amount, "Insufficient Balance");
        uint256 fee = (amount * withdrawFee) / 100;
        uint256 receiveAmount = amount - fee;

        userDeposits[msg.sender] -= amount;
        totalVaultAssets -= amount;
        payable(msg.sender).transfer(receiveAmount);
        emit Withdraw(msg.sender, amount, fee);
    }
}
