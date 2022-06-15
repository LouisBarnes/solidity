// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

error NotOwner();

contract FundContract {

    address public owner;
    // The below code is used within withdrawSelected function
    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;

    // Places the deployer address as the contract owner
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner {
     // require(msg.sender == owner);
      if (msg.sender != owner) revert NotOwner();
      _;
    }
    
    function fund() public payable {
        // Here we can set parameters of what amounts can be deposited into out contract     
        require(msg.value >= 1 ether && msg.value < 100 ether, "You need to deposit at least 1 ether but no more than 100 ether to this contract.");
        // Want to use wei instead? use the below require statement
        //require(msg.value >= 10 wei, "You need to deposit at least 10 Wei to this contract.");
        // Use the below line to specify an exact amount
        //require(msg.value == 1 ether, "You must deposit exactly 1 ether to this contract.");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    // View the contract balance using this simple function
    function contractValue() public onlyOwner view returns(uint) {
        // Only the contract owner can view the contract balance, if you want this to be viewable by all simply comment out the below require statement
        require(msg.sender == owner, "You cannot view the contract balance as you're not the owner");
        return address(this).balance;
    }

    function withdraw() payable onlyOwner public {
        // This require logic will check to ensure the owner is calling this function
       //require(msg.sender == owner, "You cannot perform this task as you're not the contract owner" );
       //payable(msg.sender).transfer(address(this).balance);
        for (uint256 i=0; i < funders.length; i++){
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "You are not the contract owner!");
    }
    // This allows you to remove ether from accounts that are within set parameter values, for instance
    // between 1 and 4 ether
    function withdrawFromFilteredAccounts(uint256 _fromEtherAmount, uint256 _toEtherAmount) payable onlyOwner public {
        uint256 amountToWithdraw;
        uint etherFrom = _fromEtherAmount*(1 ether);
        uint etherTo = _toEtherAmount*(1 ether);
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            if(addressToAmountFunded[funder] >= etherFrom && addressToAmountFunded[funder] <= etherTo) {
                amountToWithdraw = addressToAmountFunded[funder];
                addressToAmountFunded[funder] = 0;
            }
        }

        (bool callSuccess, ) = payable(msg.sender).call{value: amountToWithdraw}("");
        require(callSuccess, "You are not the contract owner!");
    }

    // Receive function to capture any loose ends
    receive() external payable {
        addressToAmountFunded[msg.sender] += msg.value;
    }
}
