// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/9-King/King.sol";
import "../src/9-King/KingFactory.sol";
import "../src/9-King/KingHack.sol";

contract KingTest is Test {
    Ethernaut ethernaut;
    KingFactory level;
    King instance;
    KingHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new KingFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance{value: 1 ether}(level);
        instance = King(payable(instanceAddress));
    }

    function testKingHack() public {
        hack = new KingHack(instanceAddress);
        uint256 prize = instance.prize();
        emit log_uint(prize);
        hack.attack{value: prize}();

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
