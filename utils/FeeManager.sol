// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract FeeManager {
    address payable public operator;
    address payable public feeReceiver;
    uint256 public fee;
    mapping(address => bool) OperatorId;

    constructor(address _operator) {
        operator = payable(_operator);
        feeReceiver = payable(_operator);
        OperatorId[_operator] = true;
    }

    modifier isOperator(address caller) {
        require(OperatorId[caller] == true, "You Are Not an Operator");
        _;
    }

    function setOperator(address newOperator) public isOperator(msg.sender) {
        OperatorId[newOperator] = true;
    }

    function setFee(uint256 newFee) public isOperator(msg.sender) {
        fee = newFee;
    }

    function setfeeReceiver(
        address payable newfeeReceiver
    ) public isOperator(msg.sender) {
        require(
            OperatorId[newfeeReceiver] == true,
            "Fee Receiver is Not an Operator"
        );
        feeReceiver = newfeeReceiver;
    }

    function transferWithFee(address payable _to, uint256 _value) public {
        uint256 feeValue = ((_value * fee) / 100);
        uint256 newValue = (_value - feeValue);
        (bool sent, bytes memory data) = _to.call{value: newValue}("");
        (bool sent2, bytes memory data2) = feeReceiver.call{value: feeValue}(
            ""
        );
        require(sent, "Error on sending founds ");
        require(sent2, "Error on sending founds to FeeOperator");
    }
}
