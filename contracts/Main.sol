// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../utils/Ownable.sol";
import "./MarketItemMain.sol";
import "./MarketPlaceMain1155.sol";
import "./Refunded.sol";
import "./MintFactoryMain1155.sol";
import "../utils/ReentrancyGuard.sol";

contract Main is Ownable, ReentrancyGuard {
    address private _contractAddress;

    function setContractAddress(address contractAddress) private onlyOwner {
        _contractAddress = contractAddress;
    }

    function createMarketItem(
        address nftContract,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable nonReentrant {
        MarketItemMain callee = MarketItemMain(payable(_contractAddress));

        callee._createMarketItem(nftContract, tokenIds, price, amounts);
    }

    function createMarketSale(
        address nftContract,
        uint256 itemId,
        uint256[] memory _tokenIds,
        uint256[] memory amounts
    ) public payable nonReentrant {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(payable(_contractAddress));

        callee._createMarketSale(nftContract, itemId, _tokenIds, amounts);
    }

    function fetchMarketItems()
        public
        view
        returns (MarketItemData.MarketItem[] memory)
    {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(payable(_contractAddress));

        return callee._fetchMarketItems();
    }

    function addRefundParameters(
        address nftContract,
        uint256 maxInfection,
        uint256 price,
        uint256 itemId
    ) public {
        Refunded callee = Refunded(_contractAddress);

        callee._addRefundParameters(nftContract, maxInfection, price, itemId);
    }

    function refundUsers(
        address payable[] memory clients,
        uint itemId
    ) public payable {
        Refunded callee = Refunded(_contractAddress);

        callee._refundUsers(clients, itemId);
    }

    function fetchParameters(
        uint itemId
    ) public view returns (RefundedData.RefundParameters memory) {
        Refunded callee = Refunded(_contractAddress);

        return callee._fetchParameters(itemId);
    }

    function deployCollection(
        string memory uri,
        uint256[] memory ids,
        uint256[] memory amount,
        string memory name,
        string memory image,
        uint256 maxInfected,
        string memory date
    ) public {
        MintFactoryMain1155 callee = MintFactoryMain1155(_contractAddress);

        callee._deployCollection(
            uri,
            ids,
            amount,
            name,
            image,
            maxInfected,
            date
        );
    }
}
