// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../utils/Ownable.sol";
import "./MarketItemMain.sol";
import "./MarketPlaceMain1155.sol";
import "./Refunded.sol";
import "./MintFactoryMain1155.sol";
import "../utils/ReentrancyGuard.sol";
import "../utils/ERC1155Receiver.sol";

contract Main is Ownable, ReentrancyGuard, ERC1155Receiver, MarketItemMain {
    // address private _marketItemContractAddress;
    address payable private _marketPlaceContractAddress;
    address private _refundedContractAddress;
    address private _mintFactoryContractAddress;
    address private _nftContractAddress;

    constructor(
        // address marketItemContractAddress,
        address payable marketPlaceContractAddress,
        address refundedContractAddress,
        address mintFactoryContractAddress,
        address nftContractAddress
    ) {
        // _marketItemContractAddress = marketItemContractAddress;
        _marketPlaceContractAddress = marketPlaceContractAddress;
        _refundedContractAddress = refundedContractAddress;
        _mintFactoryContractAddress = mintFactoryContractAddress;
        _nftContractAddress = nftContractAddress;
    }

    // function setContractAddress(address contractToSet, address contractAddress) public onlyOwner {
    //     contractToSet = contractAddress;
    // }
    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256[] tokenIds,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function createMarketItem(
        address nftContract,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable {
        // MarketItemMain callee = MarketItemMain(
        //     payable(_marketItemContractAddress)
        // );

        NFTContract nft = NFTContract(_nftContractAddress);

        _createMarketItem(
            nftContract,
            nft.getOwner(),
            _marketPlaceContractAddress,
            tokenIds,
            price,
            amounts
        );

        emit MarketItemCreated(
            1,
            address(nft),
            tokenIds,
            nft.getOwner(),
            address(0),
            price,
            false
        );
    }

    function createMarketSale(
        address nftContract,
        uint256 itemId,
        uint256[] memory _tokenIds,
        uint256[] memory amounts
    ) public payable nonReentrant returns (bytes memory) {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(
            payable(_marketPlaceContractAddress)
        );

        (bool sent, bytes memory data) = (
            (payable(_marketPlaceContractAddress))
        ).call{value: idToMarketItemData.idToMarketItem[itemId].price}("");

        require(sent, "Failed to send Ether");

        callee._createMarketSale(
            nftContract,
            msg.sender,
            itemId,
            _tokenIds,
            amounts
        );

        return data;
    }

    function fetchMarketItems()
        public
        view
        returns (MarketItemData.MarketItem[] memory)
    {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(
            payable(_marketPlaceContractAddress)
        );

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

    function refundUsers(address payable[] memory clients, uint256 itemId)
        public
        payable
    {
        Refunded callee = Refunded(_refundedContractAddress);

        callee._refundUsers(clients, itemId);
    }

    function fetchParameters(uint256 itemId)
        public
        view
        returns (RefundedData.RefundParameters memory)
    {
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
        MintFactoryMain1155 callee = MintFactoryMain1155(
            _mintFactoryContractAddress
        );

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

    // function onERC1155Received(
    //     address,
    //     address,
    //     uint256,
    //     uint256,
    //     bytes memory
    // ) public virtual override returns (bytes4) {
    //     return this.onERC1155Received.selector;
    // }

    // function onERC1155BatchReceived(
    //     address,
    //     address,
    //     uint256[] memory,
    //     uint256[] memory,
    //     bytes memory
    // ) public virtual override returns (bytes4) {
    //     return this.onERC1155BatchReceived.selector;
    // }

    // fallback() external payable {}

    // event ValueReceived(address from, uint256 amount, address to);

    // receive() external payable {
    //     emit ValueReceived(msg.sender, msg.value, address(this));
    // }
}
