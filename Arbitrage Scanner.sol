// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ArbitrageScanner {
    function getPriceDifference(uint256 price1, uint256 price2) external pure returns (uint256) {
        return price1 > price2 ? price1 - price2 : price2 - price1;
    }

    function checkArbitrageOpportunity(uint256 price1, uint256 price2, uint256 threshold) external pure returns (bool) {
        uint256 diff = getPriceDifference(price1, price2);
        return diff >= threshold;
    }
}
