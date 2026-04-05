// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DecentralizedStorageV1 is Ownable {
    struct FileData {
        string cid;
        uint256 uploadTime;
        uint256 fileSize;
    }

    mapping(address => FileData[]) public userFiles;
    uint256 public maxFilePerUser;

    event FileUploaded(address user, string cid, uint256 size);

    constructor() Ownable(msg.sender) {
        maxFilePerUser = 50;
    }

    // 上传去中心化存储文件
    function uploadFile(string calldata cid, uint256 fileSize) external {
        require(userFiles[msg.sender].length < maxFilePerUser, "File Limit Reached");
        userFiles[msg.sender].push(FileData({
            cid: cid,
            uploadTime: block.timestamp,
            fileSize: fileSize
        }));
        emit FileUploaded(msg.sender, cid, fileSize);
    }

    // 获取用户文件列表
    function getUserFiles(address user) external view returns (FileData[] memory) {
        return userFiles[user];
    }
}
