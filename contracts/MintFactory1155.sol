// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import 1155 token contract from Openzeppelin

import "./NFTContract.sol";
import "../utils/Counters.sol";
import "../utils/AccessControl.sol";

contract MintFactory1155 is AccessControl {
    bytes32 public constant MINTER = keccak256("MINTER");
    bytes32 public constant OPERATOR = keccak256("OPERATOR");

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;

    constructor(address minter, address operator) {
        _setupRole(MINTER, minter);
        _setupRole(OPERATOR, operator);
    }

    event ContractCreated(
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

    function deployCollection(
        string memory uri,
        uint256[] memory ids,
        uint256[] memory amount,
        string memory name,
        string memory image,
        uint256 maxInfected,
        string memory date
    ) public onlyRole(MINTER) {
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        address owner = msg.sender;
        NFTContract Collection = new NFTContract(uri, ids, amount, owner);
        emit ContractCreated(
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
