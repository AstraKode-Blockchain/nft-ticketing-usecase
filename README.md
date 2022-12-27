# nft-ticketing-usecase
In this repo there are 5 different Smart Contract for the Paaspo PoC.

- Marketplace1155.sol
- Mint1155_factory.sol
- Mint1155.sol
- Refunded.sol
- GetInfected.sol

 MarketPlace115.sol orchestrates the buy/sale transactions.
 Mint115_factory.sol deploys a new erc-115 collection ( Mint115.sol).
 Refunded.sol stores the refunding parameters and it calls the oracle (GetInfected.sol) to update the number of covid infected in the Noord-Brabant region. 
 If the value from oracle is greater than the maxInfected parameters it is possible to refund the clients trough a multisend function.
 GetInfected.sol Is the contract in charge to make the Oracle Call.
