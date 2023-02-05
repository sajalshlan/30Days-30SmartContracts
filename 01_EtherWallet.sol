//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

//basically writing a contract that will accept ether and only owner will be able to withdraw

contract EtherWallet{
    address payable immutable i_owner;

    constructor(){
        i_owner = payable(msg.sender);
    }

    //fund() - accept ether
    function fund() payable public {
    
    }

    //withdraw() - onlyowner
    function withdraw() payable public onlyOwner {
        (bool success, ) = address(i_owner).call{value: address(this).balance}("");
        require(success, "Failed to send ether");
    }

    //get balance function
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    modifier onlyOwner(){
        require(msg.sender == i_owner, "NOt owner");
        _;
    }
}
