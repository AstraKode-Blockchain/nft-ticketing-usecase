// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract MarketPlaceData {
    modifier priceEqualToValue(uint value, uint price) {
        require(
            value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        _;
    }

    event MarketItemSold(uint itemId, address sender);

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
