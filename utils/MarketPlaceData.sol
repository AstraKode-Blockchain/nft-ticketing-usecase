// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract MarketPlaceData {

    modifier priceEqualToValue(uint price, uint value) {
        _priceEqualToValue(price, value);
        _;
    }

    function _priceEqualToValue(uint price, uint value) private pure {
        require(
            value == price,
            "Please submit the asking price in order to complete the purchase"
        );
    }


    event MarketItemSold(uint indexed itemId, address sender);

    modifier alreadySold(bool sold ,uint indexed itemId, address sender) {
        _alreadySold(sold, itemId, sender);
        _;
    }

    function _alreadySold(bool sold, uint itemId, address sender) private {
        require(sold != true, "This Sale has alredy finished");
        emit MarketItemSold(itemId, sender);
    }


}