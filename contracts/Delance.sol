// SPDX-License-Identifier: MIT
pragma solidity 0.7.4;
pragma experimental ABIEncoderV2;

contract Delance {
    struct Request {
        string title;
        uint256 amount;
        bool locked;
        bool paid;
    }

    Request[] public requests;

    address payable public employer;
    address payable public freelancer;
    
    uint256 public deadline;
    uint256 public price;
    
    bool locked = false;
    
    
    event RequestUnlocked(bool locked);
    event RequestCreated(string title, uint256 amount, bool locked, bool paid);
    event RequestPaid(address receiver, uint256 amount);

    constructor(address payable _freelancer, uint256 _deadline) payable {
        employer = msg.sender;
        freelancer = _freelancer;
        deadline = _deadline;
        price = msg.value;
    }

    receive() external payable {
        price += msg.value;
    }

    modifier onlyFreelancer() {
        require(msg.sender == freelancer, "Only Freelancer!");
        _;
    }
    
    modifier onlyEmployer() {
        require(msg.sender == employer, "Only Employer!");
        _;
    }


    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    

    function createRequest(string memory _title, uint256 _amount)
        public
        onlyFreelancer
    {
        require(msg.sender == freelancer, "Only Freelancer!");
        Request memory request = Request({
            title: _title,
            amount: _amount,
            locked: true,
            paid: false
        });
        requests.push(request);
        
        emit RequestCreated(_title, _amount, request.locked, request.paid);
    }

    function getAllRequests() public view returns (Request[] memory) {
        return requests;
    }
    
    
    function unlockRequest(uint256 _index)
        public 
        onlyEmployer
    {
        Request storage request = requests[_index];
        require(request.locked, "Already unlocked");
        request.locked = false;
        
        emit RequestUnlocked(request.locked);
    }
    
    
    function payRequest(uint256 _index) public onlyFreelancer {
        
        require(!locked,'Reentrant detected!');
        
        Request storage request = requests[_index];
        require(!request.locked, "Request is locked");
        require(!request.paid, "Already paid");
        
        locked = true;
        
        (bool success, bytes memory transactionBytes) = freelancer.call{value:request.amount}('');
        
        require(success, "Transfer failed.");
        
        request.paid = true;
        
        locked = false;
        
        emit RequestPaid(msg.sender, request.amount);
    }
    
}