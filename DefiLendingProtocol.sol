// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DefiLendingProtocol is Ownable {
    mapping(address => mapping(address => uint256)) public userDeposits;
    mapping(address => uint256) public totalDeposits;
    uint256 public borrowInterestRate;

    event Deposited(address user, address token, uint256 amount);
    event Borrowed(address user, address token, uint256 amount);

    constructor() Ownable(msg.sender) {
        borrowInterestRate = 5; // 5%
    }

    // 存款抵押
    function deposit(address token, uint256 amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        userDeposits[msg.sender][token] += amount;
        totalDeposits[token] += amount;
        emit Deposited(msg.sender, token, amount);
    }

    // 借贷
    function borrow(address token, uint256 amount) external {
        require(userDeposits[msg.sender][token] >= amount * 2, "Insufficient Collateral");
        require(totalDeposits[token] >= amount, "Insufficient Liquidity");
        IERC20(token).transfer(msg.sender, amount);
        emit Borrowed(msg.sender, token, amount);
    }
}
