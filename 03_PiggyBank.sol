//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//to do :
//  ser can depost in the wallet
//  owner can withdraw the amount
//  contract should be destroyed after withdrawal - self destroy function just after clickin on withdraw

contract PiggyBank{
    address payable public immutable i_owner;

    //event
    event Deposit(uint amount);

    constructor() {
        i_owner = payable(msg.sender);
    }

    //function withdraw and self-destroy
    function withdraw() payable public {
        // (bool success, ) = address(this).call{value: address(this).balance}("");
        // require(success, "txn failed");

        require(i_owner == msg.sender, "you are not the owner, FU");
        selfdestruct(i_owner);
        }

    //receive when msg.data is empty
        receive() external payable{
            emit Deposit(msg.value);
        }

        fallback() external payable{}
}
