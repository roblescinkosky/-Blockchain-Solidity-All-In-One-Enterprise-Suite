// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract MultiSigWalletEnterprise {
    address[] public owners;
    uint256 public requiredConfirmations;
    mapping(address => bool) public isOwner;

    struct Transaction {
        address to;
        uint256 value;
        bool executed;
        uint256 confirmCount;
    }

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public confirmed;

    event TxSubmitted(uint256 txId, address to, uint256 value);
    event TxConfirmed(uint256 txId, address owner);

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0 && _required <= _owners.length, "Invalid Params");
        for (uint256 i = 0; i < _owners.length; i++) {
            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }
        requiredConfirmations = _required;
    }

    // 提交多签交易
    function submitTransaction(address to, uint256 value) external onlyOwner returns (uint256) {
        uint256 txId = transactions.length;
        transactions.push(Transaction({
            to: to,
            value: value,
            executed: false,
            confirmCount: 0
        }));
        emit TxSubmitted(txId, to, value);
        return txId;
    }

    // 确认交易
    function confirmTransaction(uint256 txId) external onlyOwner {
        require(!confirmed[txId][msg.sender], "Already Confirmed");
        confirmed[txId][msg.sender] = true;
        transactions[txId].confirmCount++;
        emit TxConfirmed(txId, msg.sender);
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not Owner");
        _;
    }
}
