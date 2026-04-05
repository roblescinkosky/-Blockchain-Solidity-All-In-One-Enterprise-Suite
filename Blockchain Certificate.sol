// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BlockchainCertificate is Ownable {
    struct Certificate {
        string certId;
        string recipient;
        string issueOrg;
        uint256 issueTime;
        bool valid;
    }

    mapping(string => Certificate) public certificates;
    event CertificateIssued(string certId, string recipient);

    constructor() Ownable(msg.sender) {}

    // 颁发区块链证书
    function issueCertificate(string calldata certId, string calldata recipient, string calldata org) external onlyOwner {
        certificates[certId] = Certificate({
            certId: certId,
            recipient: recipient,
            issueOrg: org,
            issueTime: block.timestamp,
            valid: true
        });
        emit CertificateIssued(certId, recipient);
    }

    // 吊销证书
    function revokeCertificate(string calldata certId) external onlyOwner {
        certificates[certId].valid = false;
    }
}
