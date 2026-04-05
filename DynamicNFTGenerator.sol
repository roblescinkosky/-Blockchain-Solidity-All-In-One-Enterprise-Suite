// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DynamicNFTGenerator is ERC721, Ownable {
    uint256 public tokenCounter;
    mapping(uint256 => string) public nftMetadataURI;
    mapping(uint256 => uint256) public nftLevel;

    event DynamicNFTMinted(uint256 tokenId, string metadata);
    event NFTLevelUp(uint256 tokenId, uint256 newLevel);

    constructor() ERC721("DynamicNFT", "DNFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    // 铸造动态NFT
    function mintDynamicNFT(string calldata metadata) external onlyOwner {
        uint256 tokenId = tokenCounter;
        _safeMint(msg.sender, tokenId);
        nftMetadataURI[tokenId] = metadata;
        nftLevel[tokenId] = 1;
        emit DynamicNFTMinted(tokenId, metadata);
        tokenCounter++;
    }

    // NFT等级升级
    function levelUpNFT(uint256 tokenId) external onlyOwner {
        require(_exists(tokenId), "NFT Not Exist");
        nftLevel[tokenId]++;
        emit NFTLevelUp(tokenId, nftLevel[tokenId]);
    }
}
