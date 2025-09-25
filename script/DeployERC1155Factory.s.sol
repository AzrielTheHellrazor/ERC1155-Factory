// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC1155Factory} from "../src/ERC1155Factory.sol";

contract DeployERC1155Factory is Script {
    ERC1155Factory public factory;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        factory = new ERC1155Factory();
        console.log("ERC1155Factory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}
