// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/10-Reentrance/Reentrance.sol";
import "../src/10-Reentrance/ReentranceFactory.sol";
import "../src/10-Reentrance/ReentranceHack.sol";

contract ReentranceTest is Test {
    Ethernaut ethernaut;
    ReentranceFactory level;
    Reentrance instance;
    ReentranceHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new ReentranceFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance{value: 1 ether}(level);
        instance = Reentrance(payable(instanceAddress));
    }

    function testReentranceHack() public {
        hack = new ReentranceHack(instanceAddress);
        hack.attack{value: 0.1 ether}();
        assertEq(instanceAddress.balance, 0);

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
