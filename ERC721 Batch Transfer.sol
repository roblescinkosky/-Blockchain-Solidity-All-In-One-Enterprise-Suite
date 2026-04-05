// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ERC721BatchTransfer {
    function batchTransferNFT(IERC721 nft, address to, uint256[] calldata tokenIds) external {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            nft.transferFrom(msg.sender, to, tokenIds[i]);
        }
    }
}
