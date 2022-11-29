// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract MarketPlaceData {
    /**
     * @dev Reverts if the bid price isn't equal to the NFT value.
     * @param value The NFT value
     * @param price The bid price
     */
    modifier priceEqualToValue(uint value, uint price) {
        require(
            value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        _;
    }

    event MarketItemSold(uint itemId, address sender);

    /**
     * @dev Reverts if the NFT alredy sold.
     * Emits MarketItemSold event.
     * @param sold The flag that check if the NFT alredy sold
     * @param itemId The NFT ID
     * @param sender The message sender
     */
    modifier alreadySold(
        bool sold,
        uint itemId,
        address sender
    ) {
        require(sold == false, "This Sale has alredy finished");
        emit MarketItemSold(itemId, sender);
        _;
    }
}
