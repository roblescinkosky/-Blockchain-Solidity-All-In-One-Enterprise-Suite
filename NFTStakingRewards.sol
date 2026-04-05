// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTStakingRewards is Ownable {
    IERC721 public immutable nft;
    IERC20 public immutable rewardToken;
    uint256 public rewardPerBlock;

    struct Stake {
        uint256 tokenId;
        uint256 startBlock;
        address owner;
    }

    mapping(uint256 => Stake) public stakes;
    mapping(address => uint256[]) public userStakedNFTs;

    event NFTStaked(address owner, uint256 tokenId);
    event NFTUnstaked(address owner, uint256 tokenId);

    constructor(IERC721 _nft, IERC20 _reward) Ownable(msg.sender) {
        nft = _nft;
        rewardToken = _reward;
        rewardPerBlock = 10**18;
    }

    // 质押NFT
    function stakeNFT(uint256 tokenId) external {
        require(nft.ownerOf(tokenId) == msg.sender, "Not Owner");
        nft.transferFrom(msg.sender, address(this), tokenId);
        stakes[tokenId] = Stake({
            tokenId: tokenId,
            startBlock: block.number,
            owner: msg.sender
        });
        userStakedNFTs[msg.sender].push(tokenId);
        emit NFTStaked(msg.sender, tokenId);
    }

    // 提取NFT+领取奖励
    function unstakeNFT(uint256 tokenId) external {
        Stake memory stake = stakes[tokenId];
        require(stake.owner == msg.sender, "Not Owner");
        uint256 blocks = block.number - stake.startBlock;
        uint256 reward = blocks * rewardPerBlock;

        delete stakes[tokenId];
        nft.transferFrom(address(this), msg.sender, tokenId);
        rewardToken.transfer(msg.sender, reward);
        emit NFTUnstaked(msg.sender, tokenId);
    }
}
