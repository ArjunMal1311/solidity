// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Upgradable Smart Contracts
// Smart contracts are immutable, once deployed they cannot be changed.
// However, their state (e.g., token balances) can change as users interact with them.

// The challenge: How can we upgrade smart contracts without losing data or changing their addresses?

// RISKS
// Centralization Risk: If a contract is upgradeable, someone (an admin) must have the power to upgrade it. If this is not decentralized (e.g., via governance), it's a security risk.
// Security Issues: Proxies and upgrade mechanisms introduce new attack surfaces.
// Complexity: Managing state variables and ensuring storage compatibility is tricky.


// Different ways to "UPGRADE" a contract
// a) The "Not Really Upgrading" Method (Parameterization)
// Instead of changing contract logic, all parameters are made adjustable via setter functions.
// Example: A staking contract with a reward rate of 1% per year could have a function to update it to 2%.
// Pros: Simple, maintains immutability.
// Cons: Can’t change logic, just tweak existing parameters.

// b) The "Social Migration" Method (Deploy a New Contract)
// Deploy a new contract and inform users to migrate.
// Example: A DeFi protocol launches "V2" and asks users to move funds from the old contract to the new one.
// Pros: Keeps immutability, avoids proxy risks.
// Cons: Inconvenient for users, and it requires manual migration of state (e.g., token balances).

// c) The Proxy Pattern (Real Upgradeability)
// Instead of replacing contracts, we use a proxy contract that delegates calls to an implementation contract.
// The proxy remains the same, but it can be pointed to a new implementation contract when needed.
// How it works:
// Users interact with the proxy contract.
// The proxy forwards calls to the implementation contract using delegatecall.
// When an upgrade is needed, a new implementation contract is deployed, and the proxy is updated to point to it.
// The state (data) is stored in the proxy, so upgrades do not lose user balances.



// 4. Risks with Proxy Contracts
// Two main risks arise when using proxies:

// a) Storage Clashes
// When delegatecall is used, the storage layout of the proxy must match the implementation contract exactly.
// If variables are re-ordered or removed, it can corrupt the data.
// Solution: Always append new variables to the end of the contract storage layout.

// b) Function Selector Clashes
// Solidity uses a 4-byte hash (function selector) to call functions.
// Two different functions (one in the proxy, one in the implementation) might have the same selector, leading to unintended behavior.
// Example:
// function upgrade() public {}
// function getPrice() public {}
// These might accidentally resolve to the same function selector.



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