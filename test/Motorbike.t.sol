// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Motorbike.sol";
import "./utils/BaseTest.sol";
import "../src/levels/MotorbikeFactory.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


// goal: selfdestruct engine.sol
// engine.sol-> _upgradeToAndCall(hackContract , selfdestruct_function) (require => upgrader)
// upgrader is set in constructor of motorbike
contract TestMotorbike is BaseTest{
    using SafeMath for uint256;
    Motorbike level;


    constructor() public{
        levelFactory = new MotorbikeFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Motorbike(levelAddress);
                
    }
    function exploitLevel(){
        //get implementation contract
        console.log(level._IMPLEMENTATION_SLOT)
    }

}
