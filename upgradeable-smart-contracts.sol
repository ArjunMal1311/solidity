// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// The priority should always be minimizing the deployment of upgradeable smart contracts


// Downside of Upgradable Smart Contracts
// From hacks to lost funds, the risks are real


// This is where the immutable nature of smart contracts comes in - a feature that developers cherish since it implies that once a contract is deployed, 
// nobody can modify or tamper with it

// The exciting thing is, though the code deployed to an address is immutable, there's still room for change. In fact, smart contracts update all the time. 
// Think token transfers or any functionality really—they frequently update their balances or variables. In other words, while the logic remains unchangeable, 
// the contracts aren't as static as they seem.



// Upgrading Smart Contracts
// 1. Not Really Upgrading Method
// involves having setter functions that can change certain parameters
// if you have a set reward that distributes a token at a 1% rate every year, you can have a setter function to adjust that distribution rate. 
// While it's easy to implement, it has limitations: unless you anticipated all possible future functionality when writing the contract, 
// you won't be able to add it in the future.


// In above one issue is about who will be setting the functions, it becomes centralized.....


// 2. Social Migration
// It involves deploying a new contract and socially agreeing to consider the new contract as the 'real' one.
// one major disadvantage is that you'd now have a new contract address for an already existing token. 
// This would require every exchange listing your token to update to this new contract address.


// 3. Proxies
// allow for state continuity and logical updates while maintaining the same contract address. 
// Users may interact with contracts through proxies without ever realizing anything changed behind the scenes.
// Transparent Proxies, Universal Upgradable Proxies (UPS), and the Diamond Pattern

// TYPES OF PROXY PATTERNS
// a) Transparent Proxy Pattern
// Admins can only call admin functions, and users can only call logic functions.
// Prevents function selector clashes.
// Downside: The contract admin cannot interact with the protocol.


// b) Universal Upgradeable Proxy Standard (UUPS)
// The upgrade logic is inside the implementation contract, instead of the proxy.
// Saves gas (fewer storage reads).
// Risk: If a developer forgets to include an upgrade function, the contract becomes non-upgradeable.


// c) Diamond Pattern (EIP-2535)
// Allows for multiple implementation contracts.
// Good for:
// Large contracts (avoids hitting the max contract size limit).
// Granular upgrades (only update specific modules instead of the whole contract).