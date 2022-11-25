// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../utils/ERC1155.sol";

contract NFTContract is ERC1155 {
    address private _owner;

    constructor(
        string memory uri,
        uint256[] memory ids,
        uint256[] memory amount,
        address owner
    )
        ERC1155(
            uri
            // "https://ipfs.moralis.io:2053/ipfs/QmS7izjgMprD3ZvP8aDBRiXbMZnxBsrUK4PJTwkcDFauij"
        )
    {
        _owner = owner;
        _mintBatch(owner, ids, amount, "");
    }

    function getOwner() public view returns (address) {
        return _owner;
    }
}
