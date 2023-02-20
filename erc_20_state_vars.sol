// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;

interface ERC20Interface{
    
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);


    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


}

contract Bitcoin2 is ERC20Interface{
    string public name = "Bitcoin";
    string public symbol = "BTC2";
    uint public decimals = 0;
    uint public override totalSupply = 0;

    address public founder;
    mapping(address => uint) public balances;


    mapping( address => mapping( address => uint ) ) credit;

    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint){
        return balances[tokenOwner];
    }

    function transfer(address _to, uint256 _value) public override returns (bool success){
        
        require(balances[msg.sender] >= _value, "You don't have sufficent balancec");
        
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    
    }

    function approve(address _spender, uint _value) public override returns (bool success){
        require(balances[msg.sender] >= _value, "Your balance is too low for the approval");
        require(_value > 0, "You have to enter a value greater than 0");
        credit[msg.sender][_spender]+=_value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
        return credit[_owner][_spender];
    } 

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(balances[_from] >= _value, "You don't have sufficient balance to make this transaction");
        require(credit[_from][msg.sender] >= _value, "You Passed your credit limit");

        credit[_from][msg.sender] -= _value;

        balances[msg.sender] += _value;
        balances[_from] -= _value;

        emit Transfer(_from, _to, _value);

        return true;


    }

}
