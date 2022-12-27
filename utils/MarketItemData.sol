// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

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
        // This mapping is used for finding market item by their id
        mapping(uint256 => MarketItem) idToMarketItem;
    }

    event ValueReceived(address from, uint256 amount, address to);

    function emitValueReceived(
        address from,
        uint256 amount,
        address to
    ) public {
        emit ValueReceived(from, amount, to);
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

    function emitMarketItemCreated(
        uint256 itemId,
        address nftContract,
        uint256[] memory tokenIds,
        address seller,
        address owner,
        uint256 price,
        bool sold
    ) public {
        emit MarketItemCreated(
            itemId,
            nftContract,
            tokenIds,
            seller,
            owner,
            price,
            sold
        );
    }

    event MarketItemSold(uint256 indexed itemId, address owner);

    function emitMarketItemSold(uint256 itemId, address owner) public {
        emit MarketItemSold(itemId, owner);
    }
}
