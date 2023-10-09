//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

contract Fundraiser{
    string description;
    uint goal;
    uint amount_raised;
    uint minimum_amount;
    uint amount_left = goal - amount_raised;
    address admin;

    struct Contributer{
        address ethaddress;
        uint amount;
    }

    Contributer[] contributers;

    event goalReached(bool _goalReached);

    constructor(uint _goal, uint _minimum_amount, string memory _description){
        goal = _goal;
        minimum_amount = _minimum_amount;
        description = _description;
        amount_raised = 0;

        admin = msg.sender;
    }

    modifier isAdmin (){
        require(admin == msg.sender, "Only admin can perform functionality");
        _;
    }

    function setGoal (uint256 _goal) public isAdmin{
        goal = _goal;
    }

    function contribute() payable public{
        require(msg.value >= minimum_amount, "Payment should not be less than the minimum amount");
        require(amount_raised <= goal, "Goal reached... no longer accepting contributions");

        Contributer memory newContributer = Contributer({
            ethaddress: msg.sender,
            amount: msg.value
        });

        amount_raised += msg.value;
        contributers.push(newContributer);

    }

    function emitGoalReached() public{
           if(goal == amount_raised){
            emit goalReached(true);
        }
    }

    function transferFunds(address ethAddress) payable public isAdmin{
        payable(ethAddress).transfer(address(this).balance);
    }

    function checkContractBalance() public view returns (uint){
        return address(this).balance;
    }

    function checkGoal() public returns(uint256){
        emitGoalReached();
        return goal;
    }

    function checkAmountRaised() public returns(uint256){
        emitGoalReached();
        return amount_raised;
    }

    function checkAmountLeft() public isAdmin returns(uint256){
        emitGoalReached();
        return goal - amount_raised;
    }
}