// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/20-Denial/Denial.sol";
import "../src/20-Denial/DenialFactory.sol";
import "../src/20-Denial/DenialHack.sol";

contract DenialTest is Test {
    Ethernaut ethernaut;
    DenialFactory level;
    Denial instance;
    DenialHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new DenialFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance{value: 1 ether}(level);
        instance = Denial(payable(instanceAddress));
    }

    function testDenialHack() public {
        hack = new DenialHack(payable(instanceAddress));
        instance.setWithdrawPartner(address(hack));

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
