// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

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

    /**
     * @dev Reverts if the function caller isn't an operator .
     * @param caller The address of the function caller.
     */
    modifier isOperator(address caller) {
        require(OperatorId[caller] == true, "You Are Not an Operator");
        _;
    }

    /**
     * @notice Utilizing isOperator.
     * @dev Add address to the operators mapping.
     * @param newOperator Address to add to the operators mapping.
     */
    function setOperator(address newOperator) public isOperator(msg.sender) {
        OperatorId[newOperator] = true;
    }

    /**
     * @notice Utilizing isOperator.
     * @dev Set the new fee of a transaction.
     * @param newFee The new fee of a transaction.
     */
    function setFee(uint256 newFee) public isOperator(msg.sender) {
        fee = newFee;
    }

    /**
     * @notice Utilizing isOperator.
     * @dev Set the transaction receiver address.
     * Reverts if the transaction receiver isn't an operator
     * @param newfeeReceiver The transaction receiver address.
     */
    function setfeeReceiver(
        address payable newfeeReceiver
    ) public isOperator(msg.sender) {
        require(
            OperatorId[newfeeReceiver] == true,
            "Fee Receiver is Not an Operator"
        );
        feeReceiver = newfeeReceiver;
    }

    /**
     * @dev Send ether with fee.
     * @param _to The transaction receiver address.
     * @param _value The transaction value.
     * @return The data of the 2 call function.
     */
    function transferWithFee(
        address payable _to,
        uint256 _value
    ) public returns (bytes memory, bytes memory) {
        uint256 feeValue = ((_value * fee) / 100);
        uint256 newValue = (_value - feeValue);
        (bool sent, bytes memory data) = _to.call{value: newValue}("");
        (bool sent2, bytes memory data2) = feeReceiver.call{value: feeValue}(
            ""
        );
        require(sent, "Error on sending funds ");
        require(sent2, "Error on sending funds to FeeOperator");

        return (data, data2);
    }
}
