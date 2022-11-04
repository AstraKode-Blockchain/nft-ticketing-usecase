// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

<<<<<<< Updated upstream
contract NFTContract is ERC1155, Ownable {


=======
contract Mint1155 is ERC1155, Ownable {
>>>>>>> Stashed changes
    constructor(
         
         string memory uri,
         uint256[] memory ids,
         uint256[] memory amount,
         address owner
    )
        ERC1155( uri
            // "https://ipfs.moralis.io:2053/ipfs/QmS7izjgMprD3ZvP8aDBRiXbMZnxBsrUK4PJTwkcDFauij" 
            )
    {
      
  _mintBatch(owner, ids,amount,"");
    }
     


}
