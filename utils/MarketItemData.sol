// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC1155.sol";

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

    function _safeBatchTransferFrom(
        address nftContract,
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) public {
        IERC1155(nftContract).safeBatchTransferFrom(
            from,
            to,
            ids,
            amounts,
            data
        );
    }
}
