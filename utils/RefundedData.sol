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

    /**
     * @dev Reverts if the iteam is already refunded.
     * Reverts if the owner isn't the msg.sender
     * @param refunded The flag that check if the item is refunded.
     */
    modifier alreadyRefunded(bool refunded) {
        require(refunded == false, "This item is alredy refunded");
        _;
    }

    /**
     * @dev Reverts if the owner isn't the sender.
     * @param owner The owner address.
     * @param sender The sender address.
     */
    modifier ownerEqualToSender(address owner, address sender) {
        require(owner == sender, "This item is alredy refunded");
        _;
    }
}
