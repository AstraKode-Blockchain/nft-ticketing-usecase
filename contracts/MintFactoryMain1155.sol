// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTContract.sol";
import "../utils/Counters.sol";
import "../utils/AccessControl.sol";
import "../utils/ContractCreated.sol";

contract MintFactoryMain1155 is AccessControl {
    bytes32 public constant MINTER = keccak256("MINTER");
    bytes32 public constant OPERATOR = keccak256("OPERATOR");

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    event _contractCreated(
        address newAddress,
        string metadata,
        string name,
        string image,
        address owner,
        bool refunded,
        uint256 maxInfected,
        string date,
        uint256 itemID
    );

    constructor(address minter, address operator) {
        _setupRole(MINTER, minter);
        _setupRole(OPERATOR, operator);
    }

    /**
     * @notice Utilizing onlyRole from AccessControl.
     * @dev Deployed a NFT collection.
     * Emits _contractCreated event.
     * @param uri The NFT URI.
     * @param ids The NFT ids.
     * @param amount The amount of NFTs to be deployed.
     * @param name The NFT collection name.
     * @param image The NFT image path.
     * @param maxInfected The maximum number of infected people in a country.
     * @param date The deployment date of the collection..
     */
    function _deployCollection(
        string memory uri,
        uint256[] memory ids,
        uint256[] memory amount,
        string memory name,
        string memory image,
        uint256 maxInfected,
        string memory date
    ) external onlyRole(MINTER) {
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        address owner = msg.sender;
        NFTContract Collection = new NFTContract(uri, ids, amount, owner);
        emit ContractCreated._contractCreated(
            address(Collection),
            uri,
            name,
            image,
            owner,
            false,
            maxInfected,
            date,
            itemId
        );
    }
}
