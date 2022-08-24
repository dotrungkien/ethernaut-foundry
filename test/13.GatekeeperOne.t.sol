// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/13-GatekeeperOne/GatekeeperOne.sol";
import "../src/13-GatekeeperOne/GatekeeperOneFactory.sol";
import "../src/13-GatekeeperOne/GatekeeperOneHack.sol";

contract GatekeeperOneTest is Test {
    Ethernaut ethernaut;
    GatekeeperOneFactory level;
    GatekeeperOne instance;
    GatekeeperOneHack hack;
    address player = makeAddr("hello gate keeper");
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new GatekeeperOneFactory();
        ethernaut.registerLevel(level);
        startHoax(player, player);

        instanceAddress = ethernaut.createLevelInstance(level);
        instance = GatekeeperOne(payable(instanceAddress));
    }

    function testGatekeeperOneHack() public {
        bytes20 p = bytes20(player);
        bytes8 key = bytes8(
            (((p << 96) >> 96) ^ ((p << 128) >> 128) ^ ((p << 144) >> 144)) <<
                96
        );

        hack = new GatekeeperOneHack(instanceAddress);

        // for (uint256 i = 0; i <= 8191; i++) {
        //     try hack.attack{gas: 819100 + i}(key, 819100 + i) {
        //         emit log_named_uint("Pass with total gas:", 819100 + i);
        //         break;
        //     } catch {}
        // }

        hack.attack{gas: 827192}(key, 827192);

        assertEq(instance.entrant(), player);

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
