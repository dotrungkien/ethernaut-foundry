// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/7-Force/Force.sol";
import "../src/7-Force/ForceFactory.sol";
import "../src/7-Force/ForceHack.sol";

contract ForceTest is Test {
    Ethernaut ethernaut;
    ForceFactory level;
    Force instance;
    ForceHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new ForceFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Force(payable(instanceAddress));
    }

    function testForceHack() public {
        hack = new ForceHack{value: 1 wei}(payable(instanceAddress));

        assertGt(instanceAddress.balance, 0);

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
