// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

// Imports
import "../utils/ChainlinkClient.sol";
import "../utils/Ownable.sol";

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
}

// Define contract that extends ChainlinkClient
contract GetInfected is ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;

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
        fee = 0.01 * 10 ** 18; // (Varies by network and job)
    }

    // Create a Chainlink request to retrieve API response
    function requestVolumeData() public returns (bytes32 requestId) {
        bytes32 reqId;

        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Set the URL to perform the GET request on
        request.add(
            "get",
            "https://api.apify.com/v2/key-value-stores/vqnEUe7VtKNMqGqFF/records/LATEST?disableRedirect=true"
        );

        // Fill required request arguments
        request.add("path", "infectedByRegion,2,infectedCount");

        // Multiply the result by 1000000000000000000 to remove decimals
        request.addInt("times", 10 ** 18);

        reqId = sendChainlinkRequestTo(oracle, request, fee);

        // Return
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    // Receive the response in the form of uint256
    function fulfill(
        bytes32 _requestId,
        uint256 _volume
    ) public recordChainlinkFulfillment(_requestId) {
        volume = _volume;
    }

    

    function withdrawToken(
        address _tokenContract,
        uint256 amount
    ) external onlyOwner {
        IERC20 tokenContract = IERC20(_tokenContract);

        tokenContract.transfer(msg.sender, amount);
    }
}
