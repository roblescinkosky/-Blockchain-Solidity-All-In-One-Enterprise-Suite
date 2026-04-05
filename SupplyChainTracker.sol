// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SupplyChainTracker is Ownable {
    struct Product {
        string productId;
        string currentStage;
        address handler;
        uint256 updateTime;
    }

    mapping(string => Product) public products;
    event ProductTracked(string productId, string stage);

    constructor() Ownable(msg.sender) {}

    // 初始化产品
    function createProduct(string calldata productId) external onlyOwner {
        products[productId] = Product({
            productId: productId,
            currentStage: "Manufactured",
            handler: msg.sender,
            updateTime: block.timestamp
        });
    }

    // 更新产品阶段
    function updateProductStage(string calldata productId, string calldata stage) external {
        products[productId].currentStage = stage;
        products[productId].handler = msg.sender;
        products[productId].updateTime = block.timestamp;
        emit ProductTracked(productId, stage);
    }
}
