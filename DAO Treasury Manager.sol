// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOTreasuryManager is Ownable {
    uint256 public treasuryBalance;
    mapping(address => bool) public authorizedManagers;

    event TreasuryFunded(uint256 amount);
    event PaymentSent(address to, uint256 amount);

    constructor() Ownable(msg.sender) {}

    // 授权金库管理员
    function addManager(address manager) external onlyOwner {
        authorizedManagers[manager] = true;
    }

    // 金库充值
    function fundTreasury() external payable {
        treasuryBalance += msg.value;
        emit TreasuryFunded(msg.value);
    }

    // 金库支付
    function sendPayment(address to, uint256 amount) external onlyManager {
        require(treasuryBalance >= amount, "Insufficient Balance");
        treasuryBalance -= amount;
        payable(to).transfer(amount);
        emit PaymentSent(to, amount);
    }

    modifier onlyManager() {
        require(authorizedManagers[msg.sender] || msg.sender == owner(), "Not Authorized");
        _;
    }
}
