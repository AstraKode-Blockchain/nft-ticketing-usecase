// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Imports
import "github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/Chainlink.sol";
import "github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/ChainlinkClient.sol";

// Define contract that extends ChainlinkClient
contract GetInfected is ChainlinkClient {
  
    // Declare contract-wide variables
    uint256 public volume;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // Contract constructor
    constructor() {
        address mumbaiLINKContract = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
      setChainlinkToken(mumbaiLINKContract);
        oracle = 0x0bDDCD124709aCBf9BB3F824EbC61C87019888bb;
        jobId = "2bb15c3f9cfc4336b95012872ff05092";
        fee = 100; // (Varies by network and job)
    }
    
    // Create a Chainlink request to retrieve API response
    function requestVolumeData() public returns (bytes32 requestId) {
        bytes32  _requestId;
        
        Chainlink.Request memory request;
        request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        Chainlink.add(request,"get", "https://api.apify.com/v2/key-value-stores/vqnEUe7VtKNMqGqFF/records/LATEST?disableRedirect=true");
        
        // Fill required request arguments
        Chainlink.add(request, "path", "infectedByRegion.2.infectedCount");
        
        // Multiply the result by 1000000000000000000 to remove decimals
        Chainlink.addInt(request, "times", 10**18);
        
        

        _requestId = sendChainlinkRequestTo(oracle, request, fee);

        // Return
        return _requestId;
    }
    
    // Receive the response in the form of uint256
    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId) {
        volume = _volume;
    }
}
