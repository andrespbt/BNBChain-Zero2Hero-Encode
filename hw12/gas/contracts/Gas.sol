// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    uint256 public constant totalSupply = 10000; // cannot be updated
    mapping(address => uint) private balances;
    Payment[] private payments;
    mapping(address => uint) public whitelist;
    address[5] public administrators;

    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }
   
    event Transfer(address, uint);

    constructor(address[5] memory _admins, uint256 _totalSupply) {
        balances[msg.sender] = _totalSupply;
        administrators = _admins;
    }
    
    
    function addToWhitelist(address _user, uint256 _tier) external {
        whitelist[_user] = _tier;
    }
    
    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata
    ) external { 
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        payments.push(Payment(1,_amount));
        emit Transfer(_recipient, _amount);
    }
    
    function updatePayment(
        address,
        uint256,
        uint256 _amount,
        uint256 _type
    ) external {
        payments[0] = Payment(_type, _amount);
    }
    
    
    function whiteTransfer(address _recipient, uint256 _amount, uint256[3] calldata) external {
        balances[msg.sender] -= _amount - whitelist[msg.sender];
        balances[_recipient] += _amount - whitelist[msg.sender];
    }

    function balanceOf(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function getTradingMode() external pure returns (bool) {
        return true;
    }

    function getPayments(address) external view returns (Payment[] memory) {
        return payments;
    }
}