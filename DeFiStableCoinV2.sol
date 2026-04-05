// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DeFiStableCoinV2 is ERC20, Ownable {
    uint256 public mintLimitPerWallet;
    mapping(address => bool) public blacklisted;

    event StableCoinMinted(address to, uint256 amount);
    event WalletBlacklisted(address user);

    constructor() ERC20("DeFiStable", "DFS") Ownable(msg.sender) {
        mintLimitPerWallet = 1000000 * 10**18;
    }

    // 铸造稳定币
    function mintStableCoin(address to, uint256 amount) external onlyOwner {
        require(!blacklisted[to], "User Blacklisted");
        require(balanceOf(to) + amount <= mintLimitPerWallet, "Exceed Wallet Limit");
        _mint(to, amount);
        emit StableCoinMinted(to, amount);
    }

    // 黑名单控制
    function setBlacklist(address user) external onlyOwner {
        blacklisted[user] = true;
        emit WalletBlacklisted(user);
    }

    // 修改单钱包铸造上限
    function updateMintLimit(uint256 newLimit) external onlyOwner {
        mintLimitPerWallet = newLimit;
    }
}
