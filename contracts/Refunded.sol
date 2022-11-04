// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "../utils/Counters.sol";
import {RefundedData} from "../utils/RefundedData.sol";

contract Refunded {
    using RefundedData for *;
    RefundedData.RefundUtils private refundUtils;
    using Counters for Counters.Counter;

    Counters.Counter private _itemIds;

    constructor() {}

    function addRefundParameters(
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

    function refundUsers(
        address payable[] memory clients,
        uint itemId
    ) public payable {
        uint256 length = clients.length;
        require(refundUtils.idRefundParameters[itemId].owner == msg.sender);
        require(refundUtils.idRefundParameters[itemId].refunded == false);
        refundUtils.idRefundParameters[itemId].refunded = true;
        for (uint256 i = 0; i < length; i++) {
            clients[i].transfer(refundUtils.idRefundParameters[itemId].price);
        }
    }

    function fetchParameters(
        uint itemId
    ) public view returns (RefundedData.RefundParameters memory) {
        //  uint itemCount = _itemIds.current();
        return refundUtils.idRefundParameters[itemId];
    }
}
