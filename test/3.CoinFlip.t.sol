// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/3-CoinFlip/CoinFlip.sol";
import "../src/3-CoinFlip/CoinFlipFactory.sol";
import "../src/3-CoinFlip/CoinFlipHack.sol";

contract CoinFlipTest is Test {
    Ethernaut ethernaut;
    CoinFlipFactory level;
    CoinFlip instance;
    CoinFlipHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new CoinFlipFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = CoinFlip(payable(instanceAddress));
    }

    function testCoinFlipHack() public {
        hack = new CoinFlipHack(instanceAddress);
        vm.roll(100);
        for (uint256 i = 0; i < 10; i++) {
            hack.attack();
            vm.roll(101 + i);
        }
        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
