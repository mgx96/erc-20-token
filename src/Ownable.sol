// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    error Ownable__NotOwner();
    error Ownable__InvalidOwnershipAssignment();

    address private s_owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        s_owner = msg.sender;
    }

    function owner() public view returns (address) {
        return s_owner;
    }

    modifier onlyOwner() {
        if (s_owner != msg.sender) {
            revert Ownable__NotOwner();
        }
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner == address(0)) {
            revert Ownable__InvalidOwnershipAssignment();
        }
        emit OwnershipTransferred(s_owner, newOwner);
        s_owner = newOwner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(s_owner, address(0));
        s_owner = address(0);
    }
}
