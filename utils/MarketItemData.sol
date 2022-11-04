// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library MarketItemData {

    struct MarketItem {
        uint itemId;
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
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenIds,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    event MarketItemSold(uint indexed itemId, address owner);


}