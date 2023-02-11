//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//to do
//  an ERC20 token with a name and a symbol
//  mint, burn, transfer functions
//  and bitch dont use openzeppelin, as you're writing those libraries only

//first need to write an interface according to the library

interface IERC20 {
    function totalSupply() external view returns(uint);

    function balanceOf(address acount) external view returns(uint);

    function transfer(address receiver, uint amount) external returns(bool);

    function allowance(address owner, address spender) external view returns(uint);

    function approve(address spender, uint amount) external returns(bool);

    function transferFrom(address sender, address receiver, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ERC20 is IERC20{

    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Shlan";
    string public symbol = "SHLAN";
    uint8 public decimals = 18;

    function transfer(address receiver, uint amount) external returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address receiver, uint amount) external returns(bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[receiver] += amount;
        emit Transfer(sender, receiver, amount);
        return true;
    }

    function mint(uint amount) external {
         balanceOf[msg.sender] += amount;
         totalSupply += amount;
         emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -=amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
