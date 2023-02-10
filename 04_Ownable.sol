//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//  to do
//  owner can set who is deploying
//  a function that checks if the current user is owner or not
//  ownership can be transferred by calling a function

contract Ownable {
    address owner;

    error NotOwner();

    event TransferOwnership(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (!(msg.sender == owner)) revert NotOwner();
        _;
    }

    //Functions:

    function currentOwner() public view returns (address) {
        return owner;
    }

    //transfer ownership
    function transferOwnership(address _newOwner) public onlyOwner {
        require(!(_newOwner == address(0)), "new address not valid");
        owner = _newOwner;
        emit TransferOwnership(msg.sender, owner);
    }

    //take the ownership back bitch - no owner
    function renounceOwnership() public virtual onlyOwner{
        owner = address(0);
    }
}
