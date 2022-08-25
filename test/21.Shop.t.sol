// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/21-Shop/Shop.sol";
import "../src/21-Shop/ShopFactory.sol";
import "../src/21-Shop/ShopHack.sol";

contract ShopTest is Test {
    Ethernaut ethernaut;
    ShopFactory level;
    Shop instance;
    ShopHack hack;
    address player = address(123456);
    address instanceAddress;

    function setUp() public {
        ethernaut = new Ethernaut();
        level = new ShopFactory();
        ethernaut.registerLevel(level);
        startHoax(player);
        instanceAddress = ethernaut.createLevelInstance{value: 1 ether}(level);
        instance = Shop(payable(instanceAddress));
    }

    function testShopHack() public {
        hack = new ShopHack(instance);
        hack.attack();

        assertLt(instance.price(), 100);

        bool levelCompleted = ethernaut.submitLevelInstance(
            payable(instanceAddress)
        );
        assert(levelCompleted);
    }
}
