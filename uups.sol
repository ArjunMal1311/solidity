// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


// Smart contracts on Ethereum are immutable — once deployed, you can’t change their logic. That’s scary if you:
// Make a bug 
// Want to improve features 
// need to improve business logic


// The proxy contract holds the storage and delegates calls to the logic contract


// The proxy forwards all calls using delegatecall to your logic contract.
// In UUPS, the logic contract must define _authorizeUpgrade() to control who can upgrade:

// function _authorizeUpgrade(address newImplementation) internal override {
//     // usually onlyOwner or other access check
// }



// function upgradeToAndCall(address newImpl, bytes calldata data)
// Changes the implementation address.
// Optionally runs an init function (like reinitializing state).



// Storage Gap (Important for Upgrades)
// uint256[50] private __gap;
// Why? To reserve empty storage slots so you can add new variables in future versions without messing up storage layout. 
// Changing variable order/type across versions can break the contract — so storage gaps give flexibility.