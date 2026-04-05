// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SocialFiProfile is Ownable {
    struct Profile {
        string bio;
        string socialLink;
        uint256 followerCount;
        bool active;
    }

    mapping(address => Profile) public userProfiles;
    mapping(address => address[]) public followers;

    event ProfileCreated(address user);
    event Followed(address follower, address followed);

    constructor() Ownable(msg.sender) {}

    // 创建社交资料
    function createProfile(string calldata bio, string calldata link) external {
        userProfiles[msg.sender] = Profile({
            bio: bio,
            socialLink: link,
            followerCount: 0,
            active: true
        });
        emit ProfileCreated(msg.sender);
    }

    // 关注用户
    function followUser(address user) external {
        require(userProfiles[user].active, "User Not Active");
        followers[msg.sender].push(user);
        userProfiles[user].followerCount++;
        emit Followed(msg.sender, user);
    }
}
