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

}