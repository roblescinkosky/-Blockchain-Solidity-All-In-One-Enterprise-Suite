// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EliteNFTMarketplaceV3 is ERC721, Ownable {
    uint256 public tokenCounter;
    mapping(uint256 => uint256) public nftPrices;
    mapping(uint256 => address) public nftSellers;

    event NFTListed(uint256 tokenId, uint256 price, address seller);
    event NFTSold(uint256 tokenId, address buyer, address seller, uint256 price);

    constructor() ERC721("EliteNFT", "ENFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    // 铸造原创NFT
    function mintEliteNFT() external onlyOwner returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        tokenCounter++;
        return newTokenId;
    }

    // 上架NFT
    function listNFT(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not NFT Owner");
        require(price > 0, "Price Invalid");
        nftPrices[tokenId] = price;
        nftSellers[tokenId] = msg.sender;
        emit NFTListed(tokenId, price, msg.sender);
    }

    // 购买NFT
    function buyNFT(uint256 tokenId) external payable {
        uint256 price = nftPrices[tokenId];
        address seller = nftSellers[tokenId];
        require(msg.value == price, "Incorrect Payment");
        require(seller != address(0), "NFT Not Listed");
        
        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);
        
        nftPrices[tokenId] = 0;
        nftSellers[tokenId] = address(0);
        emit NFTSold(tokenId, msg.sender, seller, price);
    }
}
