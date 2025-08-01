// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable{
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(){
        _owner = msg.sender;
    }

    function owner() public view returns(address){
        return _owner;
    }

    modifier onlyOwner(){
        require(_owner == msg.sender, "You need to have owner priviliges to take this action");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner{
        require(newOwner != address(0), "Invalid ownership assignment");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function renounceOwnership() public onlyOwner{
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}