// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/16-Preservation/Preservation.sol";
import "../src/16-Preservation/PreservationFactory.sol";
import "../src/16-Preservation/PreservationHack.sol";

contract PreservationTest is Test {
    Ethernaut ethernaut;
    PreservationFactory level;
    Preservation instance;
    PreservationHack hack;
    address player = makeAddr("hello gate keeper");
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new PreservationFactory();
        ethernaut.registerLevel(level);
        startHoax(player, player);

        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Preservation(payable(instanceAddress));
    }

    function testPreservationHack() public {
        hack = new PreservationHack(instanceAddress);
        hack.attack();

        assertEq(instance.owner(), player);

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
