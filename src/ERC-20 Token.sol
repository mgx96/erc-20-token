// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Ownable} from "./Ownable.sol";
import {Pausable} from "./Pausable.sol";



contract MyToken is Ownable, Pausable {
    error MyToken__InsufficientBalance();
    error MyToken__InvalidAddress();
    error MyToken__AllowanceExceeded();
    error MyToken__BurnAmountExceedsBalance();

    uint8 public constant DECIMALS = 18;
    string public name;
    string public symbol;
    uint256 public totalSupply;

    mapping(address => uint256) private s_balanceOf;
    mapping(address => mapping(address => uint256)) private s_allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) {
        totalSupply = initialSupply * (10 ** uint256(DECIMALS));
        s_balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
        name = tokenName;
        symbol = tokenSymbol;
    }

    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
        if(_to == address(0)) {
            revert MyToken__InvalidAddress();
        }
        if(s_balanceOf[msg.sender] < _value) {
            revert MyToken__InsufficientBalance();
        }
        s_balanceOf[msg.sender] -= _value;
        s_balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
        s_allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return s_allowances[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
        if(s_balanceOf[_from] < _value) {
            revert MyToken__InsufficientBalance();
        }
        if(s_allowances[_from][msg.sender] < _value) {
            revert MyToken__AllowanceExceeded();
        }

        s_balanceOf[_from] -= _value;
        s_balanceOf[_to] += _value;
        s_allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function mint(address _to, uint256 amount) public onlyOwner {
        if(_to == address(0)) {
            revert MyToken__InvalidAddress();
        }
        totalSupply += amount;
        s_balanceOf[_to] += amount;
        emit Transfer(address(0), _to, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        if(s_balanceOf[msg.sender] < amount) {
            revert MyToken__BurnAmountExceedsBalance();
        }
        s_balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balanceOf[_owner];
    }
}
