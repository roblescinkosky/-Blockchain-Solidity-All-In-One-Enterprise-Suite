// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3PaymentGateway is Ownable {
    uint256 public serviceFee;
    mapping(bytes32 => bool) public processedPayments;

    event PaymentReceived(address payer, uint256 amount, bytes32 orderId);

    constructor() Ownable(msg.sender) {
        serviceFee = 25; // 2.5%
    }

    // 订单支付
    function makePayment(bytes32 orderId) external payable {
        require(!processedPayments[orderId], "Order Paid");
        uint256 fee = (msg.value * serviceFee) / 1000;
        uint256 receive = msg.value - fee;
        payable(owner()).transfer(receive);
        processedPayments[orderId] = true;
        emit PaymentReceived(msg.sender, msg.value, orderId);
    }
}
