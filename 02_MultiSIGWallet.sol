//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

//TO-Build:
// this wallet will be owned by many owners
// any owner can submit and approve any txns
// check the history of txns and who approved them

//damn its big, but lets break it and write it, as obviously its not a test and just my second contract and i am learning right now

contract MultiSigWallet {
    event Deposit(address indexed sender, uint256 amount);
    event Submit(
        address indexed owner,
        uint256 indexed txId,
        address indexed to,
        uint256 value,
        bytes data
    );
    event Confirm(address indexed owner, uint256 indexed txId);
    event Revoke(address indexed owner, uint256 indexed txId);
    event Execute(address indexed owner, uint256 indexed txId);

    //state variables
    address[] public owners;
    uint256 public numOfConfirmationsRequired;
    mapping(address => bool) public isOwner;

    struct Transaction {
        address payable to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirmations;
    }

    Transaction[] public transactions;

    //mapping
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    //constructor
    constructor(address[] memory _owners, uint256 _numOfConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numOfConfirmationsRequired > 0 &&
                _numOfConfirmationsRequired <= _owners.length,
            "invalid number of confirmations"
        );

        for (uint256 i = 1; i < _owners.length; i++) {
            address owner = _owners[i];

            //now check if this address is neither empty nor already in the owners array
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
        numOfConfirmationsRequired = _numOfConfirmationsRequired;
    }

    //    one doubt - msg.sender should be set as an owner as the owner[0] right?

    //modifiers
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not the owner");
        _;
    }

    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "tx doesnt exist");
        _;
    }

    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    modifier notConfirmed(uint256 _txId) {
        require(
            !isConfirmed[_txId][msg.sender],
            "already confirmed by this owner"
        );
        _;
    }

    //Functions:

    function submitTransaction(
        address payable _to,
        uint256 _value,
        bytes calldata _data
    ) public onlyOwner {
        uint256 txId = transactions.length;

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        emit Submit(msg.sender, txId, _to, _value, _data);
    }

    function confirmTransaction(uint256 _txId)
        public
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
        notConfirmed(_txId)
    {
        Transaction storage transaction = transactions[_txId];

        transaction.numConfirmations += 1;
        isConfirmed[_txId][msg.sender] = true;

        emit Confirm(msg.sender, _txId);
    }

    function executeTransaction(uint256 _txId)
        public
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        Transaction storage transaction = transactions[_txId];

        require(
            transaction.numConfirmations >= numOfConfirmationsRequired,
            "cannot execute tx"
        );

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");

        transaction.executed = true;

        emit Execute(msg.sender, _txId);
    }

    function revokeTransaction(uint256 _txId)
        public
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        Transaction storage transaction = transactions[_txId];

        require(isConfirmed[_txId][msg.sender], "tx already not confirmed");

        transaction.numConfirmations -= 1;

        isConfirmed[_txId][msg.sender] = false;

        emit Revoke(msg.sender, _txId);
    }

    //fetching view functions
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    function getTransaction(uint256 _txId)
        public
        view
        returns (
            address to,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txId];

        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}

//[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db], 2
//0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, 1, 0x00
