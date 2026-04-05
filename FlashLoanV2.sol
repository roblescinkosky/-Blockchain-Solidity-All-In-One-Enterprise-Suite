// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanV2 is Ownable {
    IERC20 public immutable loanToken;
    uint256 public flashLoanFee;

    event FlashLoanExecuted(address borrower, uint256 amount, uint256 fee);

    constructor(IERC20 _token) Ownable(msg.sender) {
        loanToken = _token;
        flashLoanFee = 3; // 0.3%
    }

    // 闪电贷
    function executeFlashLoan(uint256 amount) external {
        uint256 fee = (amount * flashLoanFee) / 1000;
        uint256 totalRepay = amount + fee;
        uint256 balanceBefore = loanToken.balanceOf(address(this));
        
        loanToken.transfer(msg.sender, amount);
        (bool success,) = msg.sender.call(abi.encodeWithSignature("flashLoanCallback(uint256)", amount));
        require(success, "Callback Failed");
        
        loanToken.transferFrom(msg.sender, address(this), totalRepay);
        require(loanToken.balanceOf(address(this)) >= balanceBefore, "Repay Failed");
        emit FlashLoanExecuted(msg.sender, amount, fee);
    }
}
