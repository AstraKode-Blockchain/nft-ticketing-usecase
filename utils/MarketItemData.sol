// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC1155.sol";

library MarketItemData {
    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenIds;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    struct MarketItemUtils {
        mapping(uint256 => MarketItem) idToMarketItem;
    }

    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256[] tokenIds,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    event MarketItemSold(uint256 indexed itemId, address owner);
}
