// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MetaTransactionRelayer is Ownable {
    mapping(bytes32 => bool) public executedTx;
    event MetaTxExecuted(address indexed user, bytes32 txHash);

    constructor() Ownable(msg.sender) {}

    // 执行元交易（无Gas交易）
    function executeMetaTx(address user, bytes calldata data, bytes32 txHash) external onlyOwner {
        require(!executedTx[txHash], "Tx Executed");
        executedTx[txHash] = true;
        (bool success,) = user.call(data);
        require(success, "Tx Failed");
        emit MetaTxExecuted(user, txHash);
    }
}
