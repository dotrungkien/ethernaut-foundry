// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/14-GatekeeperTwo/GatekeeperTwo.sol";
import "../src/14-GatekeeperTwo/GatekeeperTwoFactory.sol";
import "../src/14-GatekeeperTwo/GatekeeperTwoHack.sol";

contract GatekeeperTwoTest is Test {
    Ethernaut ethernaut;
    GatekeeperTwoFactory level;
    GatekeeperTwo instance;
    address player = makeAddr("hello gate keeper");
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new GatekeeperTwoFactory();
        ethernaut.registerLevel(level);
        startHoax(player, player);

        instanceAddress = ethernaut.createLevelInstance(level);
        instance = GatekeeperTwo(payable(instanceAddress));
    }

    function testGatekeeperTwoHack() public {
        new GatekeeperTwoHack(instanceAddress);

        assertEq(instance.entrant(), player);

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
