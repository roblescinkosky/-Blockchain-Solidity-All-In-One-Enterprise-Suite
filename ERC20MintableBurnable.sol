// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20MintableBurnable is ERC20, Ownable {
    constructor() ERC20("AdvancedToken", "ADT") Ownable(msg.sender) {}

    // 铸造代币
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // 销毁代币
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
