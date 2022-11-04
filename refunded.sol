// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./utilities/Counters.sol";

contract Refunded {
    using Counters for Counters.Counter;

    Counters.Counter private _itemIds;

    constructor() {}

    struct RefundParameters {
        uint itemId;
        address nftContract;
        address owner;
        uint256 price;
        uint256 maxInfection;
        bool refunded;
    }

    mapping(uint256 => RefundParameters) private idRefundParameters;

    function addRefundParameters(
        address nftContract,
        uint256 maxInfection,
        uint256 price,
        uint256 itemId
    ) public {
        require(idRefundParameters[itemId].itemId == (0));
        require(
            idRefundParameters[itemId].owner ==
                (0x0000000000000000000000000000000000000000)
        );
        require(
            idRefundParameters[itemId].nftContract ==
                (0x0000000000000000000000000000000000000000)
        );
        idRefundParameters[itemId] = RefundParameters(
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
        require(idRefundParameters[itemId].owner == msg.sender);
        require(idRefundParameters[itemId].refunded == false);
        idRefundParameters[itemId].refunded = true;
        for (uint256 i = 0; i < length; i++) {
            clients[i].transfer(idRefundParameters[itemId].price);
        }
    }

    function fetchParameters(
        uint itemId
    ) public view returns (RefundParameters memory) {
        //  uint itemCount = _itemIds.current();
        return idRefundParameters[itemId];
    }
}
