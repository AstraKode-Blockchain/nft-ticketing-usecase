// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../utils/Ownable.sol";
import "./MarketItemMain.sol";
import "./MarketPlaceMain1155.sol";
import "./Refunded.sol";
import "./MintFactoryMain1155.sol";
import "../utils/ReentrancyGuard.sol";

contract Main is Ownable, ReentrancyGuard {
    address private _marketItemContractAddress;
    address private _marketPlaceContractAddress;
    address private _refundedContractAddress;
    address private _mintFactoryContractAddress;

    constructor(address marketItemContractAddress, address marketPlaceContractAddress, address refundedContractAddress, address mintFactoryContractAddress) {
        _marketItemContractAddress = marketItemContractAddress;
        _marketPlaceContractAddress = marketPlaceContractAddress;
        _refundedContractAddress = refundedContractAddress;
        _mintFactoryContractAddress = mintFactoryContractAddress;
    }

    function setContractAddress(address contractToSet, address contractAddress) public onlyOwner {
        contractToSet = contractAddress;
    }

    function createMarketItem(
        address nftContract,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable nonReentrant {
        MarketItemMain callee = MarketItemMain(payable(_marketItemContractAddress));

        callee._createMarketItem(nftContract, tokenIds, price, amounts);
    }

    function createMarketSale(
        address nftContract,
        uint256 itemId,
        uint256[] memory _tokenIds,
        uint256[] memory amounts
    ) public payable nonReentrant {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(payable(_marketPlaceContractAddress));

        callee._createMarketSale(nftContract, itemId, _tokenIds, amounts);
    }

    function fetchMarketItems()
        public
        view
        returns (MarketItemData.MarketItem[] memory)
    {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(payable(_marketPlaceContractAddress));

        return callee._fetchMarketItems();
    }

    function addRefundParameters(
        address nftContract,
        uint256 maxInfection,
        uint256 price,
        uint256 itemId
    ) public {
        Refunded callee = Refunded(_refundedContractAddress);

        callee._addRefundParameters(nftContract, maxInfection, price, itemId);
    }

    function refundUsers(
        address payable[] memory clients,
        uint itemId
    ) public payable {
        Refunded callee = Refunded(_refundedContractAddress);

        callee._refundUsers(clients, itemId);
    }

    function fetchParameters(
        uint itemId
    ) public view returns (RefundedData.RefundParameters memory) {
        Refunded callee = Refunded(_refundedContractAddress);

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
        MintFactoryMain1155 callee = MintFactoryMain1155(_mintFactoryContractAddress);

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
