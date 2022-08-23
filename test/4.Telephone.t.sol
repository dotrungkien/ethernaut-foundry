// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/4-Telephone/Telephone.sol";
import "../src/4-Telephone/TelephoneFactory.sol";
import "../src/4-Telephone/TelephoneHack.sol";

contract TelephoneTest is Test {
    Ethernaut ethernaut;
    TelephoneFactory level;
    Telephone instance;
    TelephoneHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new TelephoneFactory();
        ethernaut.registerLevel(level);
        startHoax(player, player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Telephone(payable(instanceAddress));
    }

    function testTelephoneHack() public {
        hack = new TelephoneHack(instanceAddress);
        hack.attack();

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
