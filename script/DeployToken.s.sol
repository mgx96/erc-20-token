//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "lib/forge-std/src/Script.sol";
import {MyToken} from "../src/ERC-20 Token.sol";

contract DeployToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000_000;

    function run() external {
        vm.startBroadcast();
        new MyToken(INITIAL_SUPPLY, "MyToken", "MTK");
        vm.stopBroadcast();
    }
}
