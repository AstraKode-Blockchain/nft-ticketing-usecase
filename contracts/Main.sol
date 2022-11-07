// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MarketItemMain.sol";
import "./MarketPlaceMain1155.sol";
import "./Refunded.sol";
import "./MintFactoryMain1155.sol";

abstract contract Main is
    MarketItemMain,
    MarketPlaceMain1155,
    Refunded,
    MintFactoryMain1155
{
    function createMarketItem(
        address nftContract,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable nonReentrant {
        _createMarketItem(nftContract, tokenIds, price, amounts);
    }

    function createMarketSale(
        address nftContract,
        uint256 itemId,
        uint256[] memory _tokenIds,
        uint256[] memory amounts
    ) public payable nonReentrant {
        _createMarketSale(nftContract, itemId, _tokenIds, amounts);
    }

    function fetchMarketItems()
        public
        view
        returns (MarketItemData.MarketItem[] memory)
    {
        return _fetchMarketItems();
    }

    function addRefundParameters(
        address nftContract,
        uint256 maxInfection,
        uint256 price,
        uint256 itemId
    ) public {
        _addRefundParameters(nftContract, maxInfection, price, itemId);
    }

    function refundUsers(
        address payable[] memory clients,
        uint itemId
    ) public payable {
        _refundUsers(clients, itemId);
    }

    function fetchParameters(
        uint itemId
    ) public view returns (RefundedData.RefundParameters memory) {
        return _fetchParameters(itemId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC1155Receiver, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function deployCollection(
        string memory uri,
        uint256[] memory ids,
        uint256[] memory amount,
        string memory name,
        string memory image,
        uint256 maxInfected,
        string memory date
    ) public onlyRole(MINTER) {
        _deployCollection(uri, ids, amount, name, image, maxInfected, date);
    }
}
