// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

import "../utils/Counters.sol";
import "../utils/ReentrancyGuard.sol";
import "../utils/ERC1155Receiver.sol";
import {MarketItemData} from "../utils/MarketItemData.sol";
import "../utils/ERC1155.sol";

contract MarketItemMain is ReentrancyGuard, ERC1155Receiver {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    using MarketItemData for *;
    MarketItemData.MarketItemUtils idToMarketItemData;

    struct ContractsAddresses {
        address payable _marketPlaceContractAddress;
        address payable _refundedContractAddress;
        address payable _mintFactoryContractAddress;
        address payable _nftContractAddress;
    }

    ContractsAddresses contractsAddressesData;

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    /**
     * @notice Utilizing nonReentrant from ReentrancyGuard.
     * @dev Create market item and store it in a mapping from id to market item struct (the struct declared in the MarketItemData library).
     * Emits MarketItemCreated event.
     * @param nftContract The NFT contract address.
     * @param fromAddress The contract address that sent the NFT.

     * @param tokenIds The market item ids.
     * @param price The market item price.
     * @param amounts The amount of market items to create.
     */ //TODO MARKET PLACE MAIN FIX ADDRESS
    function _createMarketItem(
        address nftContract,
        address fromAddress,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable nonReentrant {
        require(price > 0, "Price must be greater than 0");

        IERC1155(nftContract).safeBatchTransferFrom(
            fromAddress,
            contractsAddressesData._marketPlaceContractAddress,
            tokenIds,
            amounts,
            ""
        );

        for (uint256 i = 0; i <= (tokenIds.length - 1); i++) {
            _itemIds.increment();
            uint256 itemId = _itemIds.current();

            idToMarketItemData.idToMarketItem[itemId] = MarketItemData
                .MarketItem(
                    itemId,
                    nftContract,
                    tokenIds[i],
                    payable(fromAddress),
                    payable(address(0)),
                    price,
                    false
                );

            MarketItemData.emitMarketItemCreated(
                itemId,
                nftContract,
                tokenIds,
                fromAddress,
                address(0),
                price,
                false
            );
        }
    }

    fallback() external payable {}

    receive() external payable {
        MarketItemData.emitValueReceived(msg.sender, msg.value, address(this));
    }
}
