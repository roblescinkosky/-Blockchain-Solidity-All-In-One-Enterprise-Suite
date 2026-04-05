// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SecurityAuditSystem is Ownable {
    struct AuditReport {
        address contractAddr;
        uint8 riskLevel; // 0-安全 1-低危 2-中危 3-高危
        string auditNote;
        uint256 auditTime;
    }

    mapping(address => AuditReport) public auditRecords;
    event AuditCompleted(address contractAddr, uint8 riskLevel);

    constructor() Ownable(msg.sender) {}

    // 提交合约审计
    function submitAudit(address contractAddr, string calldata note, uint8 risk) external onlyOwner {
        auditRecords[contractAddr] = AuditReport({
            contractAddr: contractAddr,
            riskLevel: risk,
            auditNote: note,
            auditTime: block.timestamp
        });
        emit AuditCompleted(contractAddr, risk);
    }

    // 查询审计结果
    function getAuditResult(address contractAddr) external view returns (AuditReport memory) {
        return auditRecords[contractAddr];
    }
}
