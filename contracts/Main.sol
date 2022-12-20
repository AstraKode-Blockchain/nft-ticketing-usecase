// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

import "../utils/Ownable.sol";
import "./MarketItemMain.sol";
import "./MarketPlaceMain1155.sol";
import "./Refunded.sol";
import "./MintFactoryMain1155.sol";
import "../utils/ReentrancyGuard.sol";
import "../utils/ERC1155Receiver.sol";
import "../utils/FeeManager.sol";
import {MarketItemData} from "../utils/MarketItemData.sol";

contract Main is
    Ownable,
    ReentrancyGuard,
    ERC1155Receiver,
    MarketItemMain,
    FeeManager
{
    //marktetItem main to external call
    // address private _marketItemContractAddress;
    using MarketItemData for *;

    struct ContractsAddresses {
        address payable _marketPlaceContractAddress;
        address payable _refundedContractAddress;
        address payable _mintFactoryContractAddress;
        address payable _nftContractAddress;
    }

    ContractsAddresses contractsAddressesData;

    modifier isRefundEnabled() {
        require(
            address(contractsAddressesData._refundedContractAddress) !=
                address(0)
        );
        _;
    }

    constructor(
        // address marketItemContractAddress,
        address marketPlaceContractAddress,
        address refundedContractAddress,
        address mintFactoryContractAddress,
        address nftContractAddress
    ) FeeManager(msg.sender) {
        setFee(10);
        contractsAddressesData._marketPlaceContractAddress = payable(
            marketPlaceContractAddress
        );
        contractsAddressesData._refundedContractAddress = payable(
            refundedContractAddress
        );
        contractsAddressesData._mintFactoryContractAddress = payable(
            mintFactoryContractAddress
        );
        contractsAddressesData._nftContractAddress = payable(
            nftContractAddress
        );
        // _marketItemContractAddress = marketItemContractAddress;
    }

    function SetContractsAddressProperties(
        address marketPlaceContractAddress,
        address refundedContractAddress,
        address mintFactoryContractAddress,
        address nftContractAddress
    ) public onlyOwner {
        contractsAddressesData._marketPlaceContractAddress = payable(
            marketPlaceContractAddress
        );
        contractsAddressesData._refundedContractAddress = payable(
            refundedContractAddress
        );
        contractsAddressesData._mintFactoryContractAddress = payable(
            mintFactoryContractAddress
        );
        contractsAddressesData._nftContractAddress = payable(
            nftContractAddress
        );
    }

    /**
     * @dev Run _createMarketItem function from the MarketItemMain contract.
     * Emits MarketItemCreated event.
     * @param nftContract The NFT contract address.
     * @param tokenIds The market item ids.
     * @param price The market item price.
     * @param amounts The amount of market items to create.
     */
    function createMarketItem(
        address nftContract,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) public payable {
        // MarketItemMain callee = MarketItemMain(
        //     payable(_marketItemContractAddress)
        // );

        NFTContract nft = NFTContract(
            contractsAddressesData._nftContractAddress
        );

        _createMarketItem(
            nftContract,
            nft.getOwner(),
            contractsAddressesData._marketPlaceContractAddress,
            tokenIds,
            price,
            amounts
        );

        MarketItemData.emitMarketItemCreated(
            1,
            address(nft),
            tokenIds,
            nft.getOwner(),
            address(0),
            price,
            false
        );
    }

    /**
     * @notice Utilizing nonReentrant from ReentrancyGuard.
     * @dev Call _createMarketSale function from the MarketPlaceMain1155 contract.
     * Call transferWithFee function from the FeeManager contract.
     * @param nftContract The NFT contract address.
     * @param itemId The item id.
     * @param _tokenIds The token ids to sale.
     * @param amounts The amount of market items to sale.
     */
    function createMarketSale(
        address nftContract,
        uint256 itemId,
        uint256[] memory _tokenIds,
        uint256[] memory amounts
    ) public payable nonReentrant returns (bytes memory, bytes memory) {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(
            payable(contractsAddressesData._marketPlaceContractAddress)
        );

        (bytes memory data, bytes memory data2) = transferWithFee(
            payable(contractsAddressesData._marketPlaceContractAddress),
            idToMarketItemData.idToMarketItem[itemId].price
        );

        callee._createMarketSale(
            nftContract,
            msg.sender,
            itemId,
            _tokenIds,
            amounts,
            contractsAddressesData._marketPlaceContractAddress
        );

        return (data, data2);
    }

    /**
     * @dev Call _fetchMarketItems function from the MarketPlaceMain1155 contract.
     * @return A market item struct array (the struct declared in the MarketItemData library).
     */
    function fetchMarketItems()
        public
        view
        returns (MarketItemData.MarketItem[] memory)
    {
        MarketPlaceMain1155 callee = MarketPlaceMain1155(
            payable(contractsAddressesData._marketPlaceContractAddress)
        );

        return callee._fetchMarketItems();
    }

    /**
     * @dev Call _addRefundParameters function from the Refunded contract.
     * @param nftContract The NFT contract address.
     * @param maxInfection The maximum number of infected people in a country.
     * @param price The amount to be refunded to the buyer.
     * @param itemId The item id.
     */
    function addRefundParameters(
        address nftContract,
        uint256 maxInfection,
        uint256 price,
        uint256 itemId
    ) public isRefundEnabled {
        Refunded callee = Refunded(
            contractsAddressesData._refundedContractAddress
        );

        callee._addRefundParameters(nftContract, maxInfection, price, itemId);
    }

    /**
     * @dev Call _refundUsers function from the Refunded contract.
     * @param clients The addresses need to be refunded.
     * @param itemId The item id.
     */
    function refundUsers(
        address payable[] memory clients,
        uint256 itemId
    ) public payable isRefundEnabled {
        transferWithFee(
            payable(contractsAddressesData._refundedContractAddress),
            msg.value
        );
        //value>= price * by array

        Refunded callee = Refunded(
            contractsAddressesData._refundedContractAddress
        );

        callee._refundUsers(clients, itemId);
    }

    /**
     * @dev Call _fetchParameters function from the Refunded contract.
     * @param itemId The item id.
     * @return A refund parameters struct (the struct declared in the RefundParameters library).
     */
    function fetchParameters(
        uint256 itemId
    )
        public
        view
        isRefundEnabled
        returns (RefundedData.RefundParameters memory)
    {
        Refunded callee = Refunded(
            contractsAddressesData._refundedContractAddress
        );

        return callee._fetchParameters(itemId);
    }

    /**
     * @dev Call _deployCollection function from the MintFactoryMain1155 contract.
     * @param uri The NFT URI.
     * @param ids The NFT ids.
     * @param amount The amount of NFTs to be deployed.
     * @param name The NFT collection name.
     * @param image The NFT image path.
     * @param maxInfected The maximum number of infected people in a country.
     * @param date The deployment date of the collection..
     */
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
            contractsAddressesData._mintFactoryContractAddress
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
