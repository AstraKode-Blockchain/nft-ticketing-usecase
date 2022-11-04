// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library RefundedData {
    struct RefundParameters {
        uint itemId;
        address nftContract;
        address owner;
        uint256 price;
        uint256 maxInfection;
        bool refunded;
    }

    struct RefundUtils {
        mapping(uint256 => RefundParameters) idRefundParameters;
    }
}
