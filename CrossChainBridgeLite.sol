// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CrossChainBridgeLite is Ownable {
    uint256 public bridgeFee;
    mapping(bytes32 => bool) public processedTransfers;

    event CrossChainInitiated(address indexed user, uint256 amount, uint256 chainId);
    event CrossChainCompleted(bytes32 transferId);

    constructor() Ownable(msg.sender) {
        bridgeFee = 0.001 ether;
    }

    // 发起跨链转账
    function initiateCrossChain(uint256 targetChainId) external payable {
        require(msg.value > bridgeFee, "Insufficient Amount");
        uint256 transferAmount = msg.value - bridgeFee;
        bytes32 transferId = keccak256(abi.encodePacked(msg.sender, transferAmount, targetChainId, block.timestamp));
        processedTransfers[transferId] = false;
        emit CrossChainInitiated(msg.sender, transferAmount, targetChainId);
    }

    // 完成跨链
    function completeCrossChain(bytes32 transferId) external onlyOwner {
        require(!processedTransfers[transferId], "Already Processed");
        processedTransfers[transferId] = true;
        emit CrossChainCompleted(transferId);
    }

    // 修改手续费
    function updateBridgeFee(uint256 newFee) external onlyOwner {
        bridgeFee = newFee;
    }
}
