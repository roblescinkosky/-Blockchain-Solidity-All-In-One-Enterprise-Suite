// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTBlindBox is ERC721, Ownable {
    uint256 public tokenCounter;
    uint256 public boxPrice;
    mapping(uint256 => uint8) public nftRarity; // 1-普通 2-稀有 3-史诗

    event BoxOpened(uint256 tokenId, uint8 rarity);

    constructor() ERC721("BlindBoxNFT", "BBNFT") Ownable(msg.sender) {
        tokenCounter = 0;
        boxPrice = 0.05 ether;
    }

    function openBlindBox() external payable {
        require(msg.value == boxPrice, "Invalid Price");
        uint256 tokenId = tokenCounter;
        _safeMint(msg.sender, tokenId);
        uint8 rarity = uint8((uint256(keccak256(abi.encodePacked(block.timestamp, tokenId))) % 3) + 1);
        nftRarity[tokenId] = rarity;
        tokenCounter++;
        emit BoxOpened(tokenId, rarity);
    }
}
