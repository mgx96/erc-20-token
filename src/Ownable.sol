// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    address private s_owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        s_owner = msg.sender;
    }

    function owner() public view returns (address) {
        return s_owner;
    }

    modifier onlyOwner() {
        require(s_owner == msg.sender, "You need to have owner priviliges to take this action");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid ownership assignment");
        emit OwnershipTransferred(s_owner, newOwner);
        s_owner = newOwner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(s_owner, address(0));
        s_owner = address(0);
    }
}
