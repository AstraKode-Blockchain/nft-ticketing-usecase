// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CreateMarketItem.sol";

abstract contract Main is CreateMarketItem {
    function createMarketItem(
        address nftContract,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable nonReentrant {
        _createMarketItem(nftContract, tokenIds, price, amounts);
    }
}
