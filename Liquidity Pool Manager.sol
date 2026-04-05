// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiquidityPoolManager is Ownable {
    IERC20 public immutable tokenA;
    IERC20 public immutable tokenB;
    uint256 public poolRatio;

    event LiquidityAdded(uint256 amountA, uint256 amountB);

    constructor(IERC20 _a, IERC20 _b) Ownable(msg.sender) {
        tokenA = _a;
        tokenB = _b;
        poolRatio = 1;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);
        emit LiquidityAdded(amountA, amountB);
    }
}
