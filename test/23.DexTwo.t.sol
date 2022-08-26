// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/23-DexTwo/DexTwo.sol";
import "../src/23-DexTwo/DexTwoFactory.sol";
import "../src/23-DexTwo/DexTwoHack.sol";

contract DexTwoTest is Test {
    Ethernaut ethernaut;
    DexTwoFactory level;
    DexTwo instance;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new DexTwoFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = DexTwo(payable(instanceAddress));
    }

    function testDexTwoHack() public {
        DexTwoHack hack = new DexTwoHack(instance);
        hack.attack();
        address token1 = instance.token1();
        address token2 = instance.token2();

        emit log_named_uint(
            "balance of token1 of dex",
            instance.balanceOf(token1, instanceAddress)
        );

        emit log_named_uint(
            "balance of token2 of dex",
            instance.balanceOf(token2, instanceAddress)
        );

        assertTrue(
            instance.balanceOf(token1, instanceAddress) == 0 &&
                instance.balanceOf(token2, instanceAddress) == 0
        );
        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
