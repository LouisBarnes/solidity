// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract FundContract {

    address public owner;
    // Places the deployer address as the contract owner
    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint256) public addressToAmountFunded;
    
    function fund() public payable {
        // Here we can set parameters of what amounts can be deposited into out contract     
        require(msg.value >= 1 ether && msg.value < 3 ether, "You need to deposit at least 1 ether but no more than 3 ether to this contract.");
        // Use the below line to specify an exact amount
        //require(msg.value == 1 ether, "You must deposit exactly 1 ether to this contract.");
        addressToAmountFunded[msg.sender] += msg.value;
    }
    // View the contract balance using this simple function
    function contractValue() public view returns(uint) {
    // Only the contract owner can view the contract balance, if you want this to be viewable by all simply comment out the below require statement
        require(msg.sender == owner, "You cannot view the contract balance as you're not the owner");
        return address(this).balance;
    }
    // Only the contract owner can withdraw the balance of the contract
    function withdraw() payable public { 
        // This require logic will check to ensure the owner is calling this function
       require(msg.sender == owner, "You cannot perform this task as you're not the contract owner" );
       payable(msg.sender).transfer(address(this).balance);
    }
    // Receive function to capture any loose ends
    receive() external payable {
        addressToAmountFunded[msg.sender] += msg.value;
    }
}
