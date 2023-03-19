// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.6.0;

import "./utils/BaseTest.sol";
import "../src/levels/Fallout.sol";

contract TestFallout is Test{
    Fallout level;
    address owner = address(0x01);
    address player = address(0x02);

    function setUp() public{
        level = new Fallout();
    }

    function testFal1out() public{
        vm.startPrank(owner); 
        level = new Fallout();
        assertEq(level.owner(), address(0));
        vm.stopPrank();

        vm.startPrank(player);
        level.Fal1out();
        assertEq(level.owner(), player);
        vm.stopPrank();

    }

}