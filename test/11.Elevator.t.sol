// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/11-Elevator/Elevator.sol";
import "../src/11-Elevator/ElevatorFactory.sol";
import "../src/11-Elevator/ElevatorHack.sol";

contract ElevatorTest is Test {
    Ethernaut ethernaut;
    ElevatorFactory level;
    Elevator instance;
    ElevatorHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new ElevatorFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Elevator(payable(instanceAddress));
    }

    function testElevatorHack() public {
        hack = new ElevatorHack(instanceAddress);
        hack.attack();
        assertTrue(instance.top());

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
