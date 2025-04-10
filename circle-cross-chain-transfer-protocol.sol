// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Circle Cross-Chain Transfer Protocol

// Different blockchains (Ethereum, Polygon, Solana, etc.) are like different countries with their own rules and currencies.
// Now imagine you want to take $100 USDC from Ethereum and use it on Avalanche.



// Traditionally, this means:
// Locking your $100 on Ethereum in a vault.
// Creating a wrapped $100 token on Avalanche. 
// This wrapped version is just an IOU — it's not real USDC, it’s a receipt 
// saying "hey, there's $100 USDC locked on Ethereum."



// Problem
// If someone hacks the vault, your wrapped USDC is now worthless.
// Different chains end up with different USDC versions: USDC.e, avUSDC, etc. — which makes liquidity fragmented and messy.



// Think of CCTP like burning cash in one country and printing fresh new cash in another, under the supervision of a trusted authority (Circle).
// It works like this:
// Burn USDC on the source chain (say Ethereum).
// Circle attests that the burn really happened (like a notarized certificate).
// On the destination chain (say Avalanche), Circle’s smart contract mints new native USDC.


// ⚠️ No wrapping, no vaults, no IOUs — only real native USDC on both ends.
// ✅ Safer. Cleaner. Less risk. All native.


// Problem with Traditional Bridges	                                                    How CCTP Solves It
// Wrapped Token Risk – if the vault is hacked, your token’s value drops to 0	        CCTP burns and mints only native USDC
// Liquidity Fragmentation – many versions of USDC floating around	                    Only 1 real version of USDC on each chain
// Trust Assumptions – bridges often rely on external validators	                    Circle uses its own attestation service to validate burns



// 🔸 On Source Chain (Ethereum Sepolia):
// Approve CCTP to use your USDC.
// Call depositForBurn → this burns your USDC.
// CCTP emits an event → MessageSent, with messageBytes.
// Calculate the hash of that message.

// 🔸 Off-Chain:
// Circle’s Attestation Service watches the chain.
// When the burn block reaches hard finality (cannot be changed anymore), it creates a signed attestation (a proof).

// 🔸 On Destination Chain (Base Sepolia):
// You (or your app) take:
// The original messageBytes
// The attestationSignature
// Call receiveMessage → this mints USDC to the recipient’s address.
// 🔁 That’s it. The USDC is now native on Base Sepolia.





// Normal CCTP waits for hard finality (~13 mins on Ethereum).

// Circle introduced:
// Fast Transfers using soft finality (only a few seconds).
// Circle uses an allowance pool (extra USDC) to front-run the minting.
// Once hard finality is confirmed later, they settle internally.
// ⚠️ There’s a small fee for this speed boost.



// SECURITY
// Every mint needs a valid attestation from Circle — it can’t be faked.
// Rate Limits to prevent abuse:
// Max USDC per message.
// Max total minted per time window.


// Applications
// Market Makers: Quickly rebalance liquidity between chains.
// Cross-Chain Swaps: Users can swap tokens across chains in one click.
// Cross-Chain Purchases: Like buying an NFT on Polygon while holding USDC on Ethereum.
// Simplified UX: Users don’t have to switch wallets or bridge manually.


//  TL;DR — CCTP in One Sentence:
// CCTP securely burns USDC on one chain and mints it natively on another, without relying on wrapped tokens or trusted bridge operators.