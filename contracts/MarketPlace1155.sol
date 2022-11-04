// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../utils/Counters.sol";
import "../utils/ERC1155.sol";
import "../utils/ReentrancyGuard.sol";
import "../utils/ERC1155Receiver.sol";
import {MarketItemData} from "../utils/MarketItemData.sol";

contract MarketPlace1155 is ReentrancyGuard, ERC1155Receiver {
    using Counters for Counters.Counter;
    using MarketItemData for *;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold; 
    MarketItemData.MarketItemUtils private idToMarketItemData;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

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

    function createMarketSale(
        address nftContract,
        uint256 itemId,
        uint256[] memory _tokenIds,
        uint256[] memory amounts
    ) public payable nonReentrant {
        uint price = idToMarketItemData.idToMarketItem[itemId].price;

        bool sold = idToMarketItemData.idToMarketItem[itemId].sold;
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        require(sold != true, "This Sale has alredy finished");
        emit MarketItemData.MarketItemSold(itemId, msg.sender);

        idToMarketItemData.idToMarketItem[itemId].seller.transfer(msg.value);
        IERC1155(nftContract).safeBatchTransferFrom(
            address(this),
            msg.sender,
            _tokenIds,
            amounts,
            ""
        );
        idToMarketItemData.idToMarketItem[itemId].owner = payable(msg.sender);
        _itemsSold.increment();
        idToMarketItemData.idToMarketItem[itemId].sold = true;
    }

    function fetchMarketItems() public view returns (MarketItemData.MarketItem[] memory) {
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        MarketItemData.MarketItem[] memory items = new MarketItemData.MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {
            if (idToMarketItemData.idToMarketItem[i + 1].owner == address(0)) {
                uint currentId = i + 1;
                MarketItemData.MarketItem storage currentItem = idToMarketItemData.idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
