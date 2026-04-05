// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTRoyaltyManager is Ownable {
    mapping(uint256 => address) public royaltyRecipients;
    mapping(uint256 => uint256) public royaltyRates;

    event RoyaltySet(uint256 tokenId, address recipient, uint256 rate);

    constructor() Ownable(msg.sender) {}

    // 设置NFT版税
    function setRoyalty(uint256 tokenId, address recipient, uint256 rate) external onlyOwner {
        require(rate <= 1000, "Rate Too High"); // 10%上限
        royaltyRecipients[tokenId] = recipient;
        royaltyRates[tokenId] = rate;
        emit RoyaltySet(tokenId, recipient, rate);
    }

    // 计算版税
    function calculateRoyalty(uint256 tokenId, uint256 salePrice) external view returns (uint256) {
        return (salePrice * royaltyRates[tokenId]) / 1000;
    }
}
