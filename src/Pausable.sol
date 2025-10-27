// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "./Ownable.sol";

contract Pausable is Ownable {
    bool private s_paused;

    event Paused(address account);
    event Unpaused(address account);

    constructor() {
        s_paused = false;
    }

    function paused() public view returns (bool) {
        return s_paused;
    }

    modifier whenPaused() {
        require(s_paused, "Contract is not paused");
        _;
    }

    modifier whenNotPaused() {
        require(!s_paused, "Contract is paused");
        _;
    }

    function pause() public onlyOwner whenNotPaused {
        s_paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner whenPaused {
        s_paused = false;
        emit Unpaused(msg.sender);
    }
}
