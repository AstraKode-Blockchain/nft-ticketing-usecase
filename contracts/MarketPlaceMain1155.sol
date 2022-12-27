// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

import "../utils/Counters.sol";
import "../utils/ReentrancyGuard.sol";
import "../utils/ERC1155Receiver.sol";
import {MarketItemData} from "../utils/MarketItemData.sol";
import "../utils/MarketPlaceData.sol";
import "../utils/ERC1155.sol";
import "../utils/FeeManager.sol";

contract MarketPlaceMain1155 is
    ReentrancyGuard,
    ERC1155Receiver,
    MarketPlaceData,
    FeeManager
{
    using Counters for Counters.Counter;
    using MarketItemData for *;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;
    MarketItemData.MarketItemUtils private idToMarketItemData;

    address public owner;

    constructor() FeeManager(msg.sender) {
        setFee(10);
        owner = msg.sender;
    }

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
     * @notice Utilizing nonReentrant from ReentrancyGuard, priceEqualToValue and alreadySold from MarketPlaceData.
     * @dev Create an item sale and transfer the NFT to the buyer using IERC1155 safe batch transfer.
     * @param nftContract The NFT contract address.
     * @param toAddress The contract address that buy the market items.
     * @param itemId The item id.
     * @param _tokenIds The token ids to sale.
     * @param amounts The amount of market items to sale.
     */ //TODO FIX TO ADDRESS
    function _createMarketSale(
        address nftContract,
        address toAddress,
        uint256 itemId,
        uint256[] memory _tokenIds,
        uint256[] memory amounts
    )
        public
        payable
        nonReentrant
        alreadySold(
            idToMarketItemData.idToMarketItem[itemId].sold,
            itemId,
            toAddress
        )
        
   returns (bytes memory, bytes memory) {
        require(
            address(this).balance >= idToMarketItemData.idToMarketItem[itemId].price,
            "Please submit the asking price in order to complete the purchase"
        );
        

        // MODIFIER priceEqualToValue(
        //     idToMarketItemData.idToMarketItem[itemId].price,
        //     address(this).balance
        // ) 
        
    

        uint256[] memory tokenAmounts  = IERC1155(nftContract).balanceOfBatch(msg.sender, _tokenIds);
        

        require(containsZero(tokenAmounts) == false, 'Message sender does not own the token');
 
        (bytes memory data, bytes memory data2) = transferWithFee(
            payable(address(this)),
            idToMarketItemData.idToMarketItem[itemId].price
        );
        idToMarketItemData.idToMarketItem[itemId].seller.call{
            value: idToMarketItemData.idToMarketItem[itemId].price
        };
        IERC1155(nftContract).safeBatchTransferFrom(
            address(this),
            toAddress,
            _tokenIds,
            amounts,
            ""
        );
        idToMarketItemData.idToMarketItem[itemId].owner = payable(toAddress);
        _itemsSold.increment();
        idToMarketItemData.idToMarketItem[itemId].sold = true;

        return (data, data2);
    }

    /**
     * @dev Obtain all unsold items from the market.
     * @return A market item struct array (the struct declared in the MarketItemData library).
     */
    function _fetchMarketItems()
        public
        view
        returns (MarketItemData.MarketItem[] memory)
    {
        uint256 itemCount = _itemIds.current();
        uint256 unsoldItemCount = _itemIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;

        MarketItemData.MarketItem[]
            memory items = new MarketItemData.MarketItem[](unsoldItemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            if (idToMarketItemData.idToMarketItem[i + 1].owner == address(0)) {
                uint256 currentId = i + 1;
                MarketItemData.MarketItem
                    storage currentItem = idToMarketItemData.idToMarketItem[
                        currentId
                    ];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    fallback() external payable {}

    receive() external payable {
        emit MarketItemData.ValueReceived(msg.sender, msg.value, address(this));
    }

     function containsZero(uint256[] memory arr) private view returns (bool) {
    for (uint i = 0; i < arr.length; i++) {
        if (arr[i] == 0) {
            return true;
        }
    }
     }
}
