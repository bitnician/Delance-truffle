pragma solidity 0.6.9;

contract Delance {
    address public employer;
    address public freelancer;
    uint256 public deadline;

    constructor(address _freelancer, uint256 _deadline) public {
        employer = msg.sender;
        freelancer = _freelancer;
        deadline = _deadline;
    }
}