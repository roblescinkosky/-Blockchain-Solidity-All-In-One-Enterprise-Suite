// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3IdentitySystem is Ownable {
    struct Identity {
        string username;
        string avatarURI;
        uint256 registerTime;
        bool verified;
    }

    mapping(address => Identity) public identities;
    event IdentityCreated(address user, string username);

    constructor() Ownable(msg.sender) {}

    // 创建Web3身份
    function createIdentity(string calldata username, string calldata avatar) external {
        require(bytes(identities[msg.sender].username).length == 0, "Identity Exists");
        identities[msg.sender] = Identity({
            username: username,
            avatarURI: avatar,
            registerTime: block.timestamp,
            verified: false
        });
        emit IdentityCreated(msg.sender, username);
    }

    // 管理员认证身份
    function verifyIdentity(address user) external onlyOwner {
        identities[user].verified = true;
    }
}
