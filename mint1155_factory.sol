// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import 1155 token contract from Openzeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract PaasPopTickets {

  address public owner;

    constructor() {
        
     }    
event ContractCreated(address newAddress, string metadata,string name, string image);
 function deployCollection(string memory uri,uint256[] memory ids, uint256[] memory amount, string memory name, string memory image )
        public
       
  
        
    {
      owner = msg.sender; 
     NFTContract Collection = new NFTContract ( uri, ids,amount,owner);  
    emit ContractCreated(address(Collection),uri,name, image);

      
    }

}

contract NFTContract is ERC1155, Ownable {
    using SafeMath for uint256;

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