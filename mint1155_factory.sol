// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import 1155 token contract from Openzeppelin

import "./mint1155.sol";
 import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";


contract PaasPopTickets {
   using Counters for Counters.Counter;
  Counters.Counter private _itemIds;

  mapping (address => bool) public Operators;
    constructor() {
      Operators[msg.sender]=true;
        
     }    

     mapping (address => bool) public Minters;
event MinterRoleAssigned(address minterAddress);

    function setMinterRole(address _wallet) public{
      require (Operators[msg.sender] == true);
        Minters[_wallet]=true;
        emit MinterRoleAssigned (_wallet);
    }
        function setOperatorRole(address _operator) public{
           require (Operators[msg.sender] == true);
        Operators[_operator]=true;
    }


     

event ContractCreated(address newAddress, string metadata,string name, string image, address owner, bool refunded, uint256 maxInfected,string date, uint256 itemID);
 function deployCollection(string memory uri,uint256[] memory ids, uint256[] memory amount, string memory name, string memory image,uint256 maxInfected, string memory date )
        public
       
      
        
    {
           require( Minters[msg.sender] == true);
           _itemIds.increment();
            uint256 itemId = _itemIds.current();
      address owner = msg.sender; 
     NFTContract Collection = new NFTContract ( uri, ids,amount,owner);  
    emit ContractCreated(address(Collection),uri,name, image, owner, false,maxInfected,date, itemId);

      
    }

}

