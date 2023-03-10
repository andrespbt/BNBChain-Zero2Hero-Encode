// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract DogCoin {

    uint256 private _totalSupply;
    address private _owner;

    event ChangeSupply(
        uint256 indexed _newSupply 
    );

    event Transfer(
        uint256 indexed _amount,
        address indexed _sender
    );

    struct Payment {
        uint256 _amount;
        address _sender;
    }

    mapping(address => uint256) private _balances;
    mapping (address => Payment[]) private _payments;

    constructor() {
         _totalSupply = 2000000;
         _owner = msg.sender;
         _balances[_owner] = _totalSupply;
    }

    modifier onlyOwner {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }
    function getOwner() public view returns(address) {
        return _owner;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _address) public view returns(uint256){
        return _balances[_address];
    }

    function paymentsOf(address _address) public view returns(Payment[] memory) {
        return _payments[_address];
    }

    function changeTotalSupply() public onlyOwner {
        _totalSupply += 1000;
        emit ChangeSupply(_totalSupply);
    }

    function transfer(uint256 _amount, address payable _to) public returns(bool) {
        require(msg.sender != 0x000000000000000000000000000000000000dEaD, "Transfer from the zero address");
        require(_to != 0x000000000000000000000000000000000000dEaD, "Transfer to the zero address");
        require(msg.sender.balance >= _amount, "Insufficient amount in wallet");

        _balances[msg.sender] -= _amount;
        _balances[_to] += _amount;

        emit Transfer(_amount, msg.sender);

        _payments[msg.sender].push(Payment(_amount, msg.sender));

        return true;

    }

}

