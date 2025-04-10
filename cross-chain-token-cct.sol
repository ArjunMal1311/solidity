// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Cross Chain Token (CCT)


// Problem of Liquidity Fragmentation
// Its same as USD can be used in US but not in India
// USDC on Polygon and same USDC on Arbitrum

// All liquidity (money) is scattered across different chains
// Plus if you are a token developer and want to make token work on different chains
// you need support from third party bridge providers

// Chainlink’s CCT Standard (Cross Chain Token) is built to solve these problems
// 1. Unify liquidity (so your token works smoothly across chains).
// 2. Give developers full control to make any token cross-chain ready without asking anyone for permission.
// 3. Build on CCIP – Chainlink’s secure messaging layer across blockchains.


// Chainlink’s Cross-Chain Interoperability Protocol (CCIP) is like a FedEx for data and tokens across blockchains.
// Imagine you want to send a package (token or message) from Ethereum to Arbitrum. CCIP:
// -> Picks it up on Ethereum (source chain)
// -> Delivers it to Arbitrum (destination chain)
// -> Guarantees it's secure (via decentralized oracles + a risk-check system)

// It ensures messages and tokens don’t get lost, duplicated, or hijacked.


// CCT solves this by making the same token interoperable across chains with a shared pool or accounting system.
// Old way
// Hey bridge protocol, can you support my token?

// New way with CCT: "Here’s my token, I’ll make it cross-chain on my own using Chainlink tools. No permission needed."
// You can enable your token to be cross-chain just by following the CCT architecture — no need to wait for anyone. You stay in full control.


// Key Features
// 1. Enhanced Security (Defense-in-Depth)
// 2. Programmable Token Transfers Like Send 50 USDC to Arbitrum and deposit it into Aave lending pool automatically.
// 3. Unified Liquidity Models CCT uses smart Token Pools with two models:
//      -> Lock/Unlock [Total supply remains constant, You lock 100 tokens on Chain A → Unlock 100 on Chain B]
//      -> Burn/Mint [You burn tokens on the source chain → Mint the same on the destination]



// Core Architecture
// 1. Token Contract
//    -> Your actual token, usually an ERC20.
//    -> For Burn/Mint, it must have mint() and burn() functions.
//    -> For Lock/Unlock, you just need transfer().

// 2. Token Pool
//    -> Deployed on each chain.
//    -> Manages the locking, burning, unlocking, or minting.
//    -> Standard templates (BurnMintTokenPool, LockReleaseTokenPool)

// 3. TokenAdminRegistry
//    -> Registry that says: "Who is allowed to set rules and manage this token's cross-chain stuff?"
//    -> Think of it like a whitelist or permission book.
//    -> You (the admin) get access and can configure pools, rate limits, etc.

// 4. CCIP Router
//    -> This is Chainlink’s main contract you interact with when sending messages or tokens across chains.


// Dev Working
// Setup
// Deploy Contracts (on Both Chains)
// Register Admin -> TokenAdminRegistry
// Connect Chains using applyChainUpdates()
// Send Tokens Approve, then use ccipSend(destinationSelector, message) token Amount, Data....
// Monitor on CCIP Explorer