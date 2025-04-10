// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Blockchain Bridges
// Think of each blockchain like a separate island with its own currency, rules, and people. 
// These islands don’t naturally talk to each other.
// A blockchain bridge acts like a ferry or tunnel, allowing you to move 
// stuff (like tokens, NFTs, or data) from one island (blockchain) to another.


// Bridging = Sending assets (like ETH, USDC) between chains.
// Cross-Chain Messaging = Sending data or messages between chains.

// Different blockchains don’t share assets. If you have ETH on Ethereum but want to use zkSync, 
// you’ll need a bridge to move that ETH over—just like exchanging dollars to pounds when traveling to the UK.

// How Bridges Work (4 Common Methods)
// 1. 🔥 Burn-and-Mint
// Token is burned on Chain A.
// Same amount is minted on Chain B.
// Total supply stays the same.
// (Think: "Delete here, create there.")

// 2. 🔒 Lock-and-Unlock
// Token is locked on Chain A.
// Same token is unlocked from a vault on Chain B.
// Needs enough tokens on both sides to work smoothly.
// Think: "Put in locker A, take out from locker B."

// 3. 🧊 Lock-and-Mint (Wrapped Assets)
// Original token is locked.
// A wrapped version (like USDC.e) is minted on the new chain.
// Wrapped = IOU for the real token.
// Think: "Lock the real one, mint a copy."

// 4. 🔥 Burn-and-Unlock
// Wrapped token is burned.
// Original token is unlocked on the home chain.
// Think: "Burn the copy, get the original back."


// 🔐 Bridge Security Models
// 1. 🏢 Centralized Bridges
// Run by a single team or company.
// Faster, but you have to trust them.

// If they get hacked or act shady, you could lose funds.

// 2. 🌐 Decentralized Bridges
// Run by a network of nodes.
// No single point of failure.
// More aligned with blockchain’s values.
// Example: Chainlink’s CCIP.




// WHY CROSS CHAIN COMMUICATION MATTERS?
// Imagine you have two banks: one in the US and one in Europe. 
// You have money in both, but you can’t directly move money between them—they don't use the same systems. 
// You'd need SWIFT or some other system to bridge them.


// Same thing in crypto:
// Ethereum is like the US bank.
// Arbitrum or ZkSync is like the European bank.
// They can’t talk to each other natively. So if you want to move tokens or data from one to another, you need a bridge



// Chainlink’s CCIP is like SWIFT for blockchains—a protocol that lets you send messages and money (tokens) across blockchains, securely and reliably.
// You can send:
// 📦 Only tokens (e.g. send USDC from Ethereum to Arbitrum)
// 📨 Only data (e.g. “Hey, smart contract on Arbitrum, do this thing!”)
// 💡 Both at the same time (e.g. “Take my tokens and do something with them”)


// Step 1
// Place an order online (interact with Router Contract)
// Send 10 Books to my friend in Paris with Happy Birthday message
// (Tokens = 10 Books, Data = Happy Birthday message)

// Step 2 (OnRamp - Packaging the Order)
// OnRamp Contract is like FedEx, check order package book and prep for shipping
// if books (tokens) are involved:
//      -> Fedex locks them in a secure facility until delivery
//      -> Burns them and says We will reprint these on delivery

// Step 3 (OffChain Oracle Network)
// Package is picked up and tracked through a decentralized FedEx system
// -> The workers sign and commit details into their system
// -> they create receipt (Merkle Root) saying what's inside
// -> Recieve that in Paris and say yes we got it, time to deliver

// Imagine seperate Secruity Agency [RMN] is watching the shipment
// They bless packages that looks good and curse packages that look bad

// Key terms [Curse and Bless]
// Bless = Approve and say yes we got it, time to deliver
// Curse = Reject and say we didn't get it, send back

// Step 4 (OffRamp - Unpackaging the Order)
// Unpack the package in Paris
// If books (tokens) are involved:
//      -> Fedex unlocks them from the facility
//      -> Mint new books (tokens) and send them to my friend

// Step 5 (Router on Destination Chain)
// The workers on the receiving end check the receipt (Merkle Root)
// If it's blessed, they unlock the books (tokens)
// Package is delivered to friend (EOA wallet or smart contract)


// Why CCIP is safer than traditional bridges?
// 1. Many independent couriers (oracle nodes) to verify everything.
// 2. Separate security surveillance (RMN) to catch attacks, bugs, or fake packages.
// 3. Rate limits so even if something goes wrong, only a small amount can leak.
