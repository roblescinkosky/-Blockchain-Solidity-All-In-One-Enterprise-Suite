// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3AuthSystem is Ownable {
    mapping(address => bool) public authenticatedUsers;
    event UserAuthenticated(address user);

    constructor() Ownable(msg.sender) {}

    function authenticateUser(address user) external onlyOwner {
        authenticatedUsers[user] = true;
        emit UserAuthenticated(user);
    }

    function checkAuth(address user) external view returns (bool) {
        return authenticatedUsers[user];
    }
}
