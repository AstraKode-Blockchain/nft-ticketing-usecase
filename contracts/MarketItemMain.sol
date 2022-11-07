// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../utils/Counters.sol";
import "../utils/ReentrancyGuard.sol";
import "../utils/ERC1155Receiver.sol";
import "../utils/ERC1155.sol";
import {MarketItemData} from "../utils/MarketItemData.sol";

abstract contract MarketItemMain is ReentrancyGuard, ERC1155Receiver {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    using MarketItemData for *;
    MarketItemData.MarketItemUtils private idToMarketItemData;

    function _createMarketItem(
        address nftContract,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable nonReentrant {
        require(price > 0, "Price must be greater than 0");

        IERC1155(nftContract).safeBatchTransferFrom(
            msg.sender,
            address(this),
            tokenIds,
            amounts,
            ""
        );

        for (uint i = 0; i <= (tokenIds.length - 1); i++) {
            _itemIds.increment();
            uint256 itemId = _itemIds.current();

            idToMarketItemData.idToMarketItem[itemId] = MarketItemData
                .MarketItem(
                    itemId,
                    nftContract,
                    tokenIds[i],
                    payable(msg.sender),
                    payable(address(0)),
                    price,
                    false
                );

            emit MarketItemData.MarketItemCreated(
                itemId,
                nftContract,
                tokenIds[i],
                msg.sender,
                address(0),
                price,
                false
            );
        }
    }
}
