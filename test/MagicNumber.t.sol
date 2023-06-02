// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/MagicNum.sol";
import "../src/levels/MagicNumFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestMagicNum is BaseTest{
    using SafeMath for uint256;
    MagicNum level;


    constructor() public{
        levelFactory = new MagicNumFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = MagicNum(levelAddress);
                
    }

    function exploitLevel() internal override{
        vm.prank(player, player);
        address solverInstance;
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, shl(0x68, 0x69602A60005260206000F3600052600A6016F3))
            solverInstance := create(0, ptr, 0x13)
        }

        level.setSolver(solverInstance);

        assertEq(
            Solver(solverInstance).whatIsTheMeaningOfLife(),
            0x000000000000000000000000000000000000000000000000000000000000002a
        );

        vm.stopPrank();
    }
}
