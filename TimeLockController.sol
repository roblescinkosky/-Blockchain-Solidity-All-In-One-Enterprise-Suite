// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TimeLockController is Ownable {
    mapping(bytes32 => uint256) public queuedTransactions;
    uint256 public delay;

    event TransactionQueued(bytes32 txId, uint256 executeTime);

    constructor() Ownable(msg.sender) {
        delay = 3600; // 1小时
    }

    // 队列延迟交易
    function queueTransaction(bytes32 txId) external onlyOwner {
        uint256 executeTime = block.timestamp + delay;
        queuedTransactions[txId] = executeTime;
        emit TransactionQueued(txId, executeTime);
    }

    // 执行延迟交易
    function executeTransaction(bytes32 txId) external onlyOwner {
        require(block.timestamp >= queuedTransactions[txId], "Not Ready");
        queuedTransactions[txId] = 0;
    }
}
