// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;

contract Delance {
    struct Request {
        string title;
        uint256 amount;
        bool locked;
        bool paid;
    }

    Request[] public requests;

    address public employer;
    address public freelancer;
    uint256 public deadline;
    uint256 price;

    constructor(address _freelancer, uint256 _deadline) public payable {
        employer = msg.sender;
        price = msg.value;
        freelancer = _freelancer;
        deadline = _deadline;
    }

    modifier onlyFreelancer() {
        require(msg.sender == freelancer, "Only Freelancer!");
        _;
    }

    function createRequest(string memory _title, uint256 _amount)
        public
        onlyFreelancer
    {
        Request memory request = Request({
            title: _title,
            amount: _amount,
            locked: true,
            paid: false
        });

        requests.push(request);
    }

    receive() external payable {
        price += msg.value;
    }
}
