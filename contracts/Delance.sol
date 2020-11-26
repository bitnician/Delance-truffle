// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;

contract Delance {
    enum Status {COMPLETED, CENCELED, PENDING}

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
    uint256 public createdAt;
    uint256 public price;
    uint256 public remainingPayments;
    Status public status;

    event RequestCreated(string title, uint256 amount, bool locked, bool paid);
    event RequestUnlocked(bool locked);
    event RequestPaid(address receiver, uint256 amount);
    event ProjectCompleted(
        address employer,
        address freelancer,
        uint256 amount,
        Status status
    );
    event ProjectCanceled(uint256 remainingPayments, Status status);

    constructor(
        address payable _employer,
        address payable _freelancer,
        uint256 _deadline,
        uint256 _price
    ) public {
        employer = _employer;
        freelancer = _freelancer;
        deadline = _deadline;
        createdAt = now;
        price = _price;
        remainingPayments = _price;
        status = Status.PENDING;
    }

    modifier onlyEmployer() {
        require(msg.sender == employer, "Only Employer!");
        _;
    }

    modifier onlyFreelancer() {
        require(msg.sender == freelancer, "Only Freelancer!");
        _;
    }

    modifier onlyPendingProject() {
        require(status == Status.PENDING, "Only pending!");
        _;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function createRequest(string memory _title, uint256 _amount)
        public
        onlyFreelancer
        onlyPendingProject
    {
        require(_amount <= remainingPayments, "High amount!");

        Request memory request = Request({
            title: _title,
            amount: _amount,
            locked: true,
            paid: false
        });

        requests.push(request);

        emit RequestCreated(_title, _amount, request.locked, request.paid);
    }

    function unlockRequest(uint256 _index)
        public
        onlyEmployer
        onlyPendingProject
    {
        Request storage request = requests[_index];
        require(request.locked, "Already unlocked");
        request.locked = false;

        emit RequestUnlocked(request.locked);
    }

    function payRequest(uint256 _index) public onlyFreelancer {
        Request storage request = requests[_index];
        require(!request.locked, "Request is locked");
        require(!request.paid, "Already paid");

        remainingPayments -= request.amount;

        freelancer.transfer(request.amount);
        request.paid = true;

        emit RequestPaid(msg.sender, request.amount);
    }

    function completeProject() public onlyEmployer onlyPendingProject {
        status = Status.COMPLETED;
        freelancer.transfer(remainingPayments);

        emit ProjectCompleted(employer, freelancer, remainingPayments, status);
    }

    function cancelProject() public onlyEmployer onlyPendingProject {
        require(now > deadline);
        status = Status.CENCELED;
        employer.transfer(remainingPayments);

        emit ProjectCanceled(remainingPayments, status);
    }

    function increaseDeadline(uint256 amount)
        public
        onlyEmployer
        onlyPendingProject
    {
        deadline += amount;
    }

    receive() external payable {}
}
