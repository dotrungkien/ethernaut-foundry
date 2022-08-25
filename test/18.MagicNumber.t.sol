// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/18-MagicNumber/MagicNum.sol";
import "../src/18-MagicNumber/MagicNumFactory.sol";

contract MagicNumTest is Test {
    Ethernaut ethernaut;
    MagicNumFactory level;
    MagicNum instance;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new MagicNumFactory();
        ethernaut.registerLevel(level);
        startHoax(player);

        instanceAddress = ethernaut.createLevelInstance(level);
        instance = MagicNum(payable(instanceAddress));
    }

    function testMagicNumHack() public {
        address solver;

        // RUNTIME CODE
        // 602a -- push 42
        // 6000 -- push 00
        // 52   -- mstore in 00 value 42
        // 6020 -- push 32 bytes to return
        // 6000 -- push mem address to return (00)
        // f3   -- return from 00 size 32 bytes

        // CREATION codes
        // 69<RUNTIMECODE> -- push 10 bytes of runtime code
        // 6000 -- push 00
        // 52   -- mstore in 00 the run time code
        // 600a -- push 10 bytes
        // 6016 -- memory address to start returning from (22)
        // f3   -- return from 22 size 10 bytes
        bytes
            memory creationCodes = hex"69602a60005260206000f3600052600a6016f3";

        assembly {
            solver := create(0, add(creationCodes, 0x20), mload(creationCodes))
        }

        instance.setSolver(solver);
        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
