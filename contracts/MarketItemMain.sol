// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../utils/Counters.sol";
import "../utils/ReentrancyGuard.sol";
import "../utils/ERC1155Receiver.sol";
import {MarketItemData} from "../utils/MarketItemData.sol";
import "../utils/ERC1155.sol";

contract MarketItemMain is ReentrancyGuard, ERC1155Receiver {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    using MarketItemData for *;
    MarketItemData.MarketItemUtils idToMarketItemData;

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    function _createMarketItem(
        address nftContract,
        address fromAddress,
        address toAddress,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable nonReentrant {
        require(price > 0, "Price must be greater than 0");

        IERC1155(nftContract).safeBatchTransferFrom(
            fromAddress,
            toAddress,
            tokenIds,
            amounts,
            ""
        );

        for (uint256 i = 0; i <= (tokenIds.length - 1); i++) {
            _itemIds.increment();
            uint256 itemId = _itemIds.current();

            idToMarketItemData.idToMarketItem[itemId] = MarketItemData
                .MarketItem(
                    itemId,
                    nftContract,
                    tokenIds[i],
                    payable(fromAddress),
                    payable(address(0)),
                    price,
                    false
                );

            emit MarketItemData.MarketItemCreated(
                itemId,
                nftContract,
                tokenIds,
                fromAddress,
                address(0),
                price,
                false
            );
        }
    }

    fallback() external payable {}

    event ValueReceived(address from, uint256 amount, address to);

    receive() external payable {
        emit ValueReceived(msg.sender, msg.value, address(this));
    }
}
