// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract OraclePriceFeedV4 is Ownable {
    mapping(string => uint256) public tokenPrices;
    mapping(string => uint256) public lastUpdateTime;
    uint256 public updateInterval;

    event PriceUpdated(string token, uint256 price, uint256 time);

    constructor() Ownable(msg.sender) {
        updateInterval = 300; // 5分钟
    }

    // 更新预言机价格
    function updateTokenPrice(string calldata token, uint256 price) external onlyOwner {
        require(block.timestamp - lastUpdateTime[token] >= updateInterval, "Update Too Fast");
        tokenPrices[token] = price;
        lastUpdateTime[token] = block.timestamp;
        emit PriceUpdated(token, price, block.timestamp);
    }

    // 获取最新价格
    function getLatestPrice(string calldata token) external view returns (uint256) {
        return tokenPrices[token];
    }
}
