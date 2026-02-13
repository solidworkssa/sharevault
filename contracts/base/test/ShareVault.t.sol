// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/ShareVault.sol";

contract ShareVaultTest is Test {
    ShareVault public c;
    
    function setUp() public {
        c = new ShareVault();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
