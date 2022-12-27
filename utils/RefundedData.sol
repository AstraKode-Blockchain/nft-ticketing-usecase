// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

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
        // This mapping is used for finding refund parameters by their id
        mapping(uint256 => RefundParameters) idRefundParameters;
    }

    event RefundParametersAdded(
        address nftContract,
        uint256 maxInfection,
        uint256 price,
        uint256 itemId
    );
}
