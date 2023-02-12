//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//todo
//  just a erc20 token using open zeppelin library.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract mera is ERC20{
    constructor(uint initialSupply) ERC20("Shlan", "SHLAN") {
        _mint(msg.sender, initialSupply);
    }
}
