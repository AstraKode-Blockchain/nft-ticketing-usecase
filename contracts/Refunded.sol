// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;
import "../utils/Counters.sol";
import {RefundedData} from "../utils/RefundedData.sol";

contract Refunded {
    using RefundedData for RefundedData.RefundUtils;
    using Counters for Counters.Counter;

    Counters.Counter private _itemIds;
    RefundedData.RefundUtils private refundUtils;

    constructor() {}

    //test event

    /**
     * @dev Store refund parameters in a map (map declared in the RefundedData library).
     * Reverts if one of the owner and NFT contract addresses is equal to 0.
     * @param nftContract The NFT contract address.
     * @param maxInfection The maximum number of infected people in a country.
     * @param price The amount to be refunded to the buyer.
     * @param itemId The item id.
     */

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

    function _addRefundParameters(
        address nftContract,
        uint256 maxInfection,
        uint256 price,
        uint256 itemId
    ) public {
        require(refundUtils.idRefundParameters[itemId].itemId == (0));
        require(
            refundUtils.idRefundParameters[itemId].owner ==
                (0x0000000000000000000000000000000000000000)
        );
        require(
            refundUtils.idRefundParameters[itemId].nftContract ==
                (0x0000000000000000000000000000000000000000)
        );
        refundUtils.idRefundParameters[itemId] = RefundedData.RefundParameters(
            itemId,
            nftContract,
            (msg.sender),
            price,
            maxInfection,
            false
        );
    }

    /**
     * @notice Utilizing alreadyRefunded and ownerEqualToSender from RefundedData.
     * Reverts if max infection of item id is bigger then APIConsumer.volume.
     * @dev Refund all the buyer of the item.
     * @param clients The addresses need to be refunded.
     * @param itemId The item id.
     */
    function _refundUsers(
        address payable[] memory clients,
        uint itemId
    )
        public
        payable
        alreadyRefunded(refundUtils.idRefundParameters[itemId].refunded)
        ownerEqualToSender(
            refundUtils.idRefundParameters[itemId].owner,
            msg.sender
        )
    {
        //  require(APIConsumer.volume >=  idRefundParameters[itemId].maxInfection);
        uint256 length = clients.length;
        refundUtils.idRefundParameters[itemId].refunded = true;
        for (uint256 i = 0; i < length; i++) {
            (bool success, bytes memory data) = clients[i].call{
                value: refundUtils.idRefundParameters[itemId].price
            }("");
            require(success, "Error on sending founds");
        }
    }

    /**
     * @dev Obtain all refund parameters.
     * @param itemId The item id.
     * @return A refund parameters struct (the struct declared in the RefundParameters library).
     */
    function _fetchParameters(
        uint itemId
    ) public view returns (RefundedData.RefundParameters memory) {
        //  uint itemCount = _itemIds.current();
        return refundUtils.idRefundParameters[itemId];
    }

    fallback() external payable {}

    receive() external payable {}
}
