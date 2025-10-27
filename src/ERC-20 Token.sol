// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Ownable} from "./Ownable.sol";
import {Pausable} from "./Pausable.sol";

contract MyToken is Ownable, Pausable {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private s_balanceOf;
    mapping(address => mapping(address => uint256)) private s_allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) {
        totalSupply = initialSupply * (10 ** uint256(decimals));
        s_balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
        name = tokenName;
        symbol = tokenSymbol;
    }

    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(s_balanceOf[msg.sender] >= _value, "Insufficient balance");
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
        require(s_balanceOf[_from] >= _value, "Insufficient balance");
        require(s_allowances[_from][msg.sender] >= _value, "Allowance exceeded");

        s_balanceOf[_from] -= _value;
        s_balanceOf[_to] += _value;
        s_allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Invalid address");
        totalSupply += amount;
        s_balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        require(s_balanceOf[msg.sender] >= amount, "The specified burn amount exceeds your balance");
        s_balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
