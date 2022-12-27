// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ContractCreated {
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

    function emitEvent(
        address newAddress,
        string memory metadata,
        string memory name,
        string memory image,
        address owner,
        bool refunded,
        uint256 maxInfected,
        string memory date,
        uint256 itemID
    ) public {
        emit _contractCreated(
            newAddress,
            metadata,
            name,
            image,
            owner,
            refunded,
            maxInfected,
            date,
            itemID
        );
    }
}
