// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Blockchain Oracles

// Oracles play a foundational role in the creation of the verifiable web, connecting 
// blockchains that would otherwise be isolated to offchain data and compute, and enabling 
// interoperability between blockchains.



// For example, let’s assume Alice and Bob want to bet on the outcome of a sports match. 
// Alice bets $20 on team A and Bob bets $20 on team B, with the $40 total held in escrow 
// by a smart contract. When the game ends, how does the smart contract know whether to 
// release the funds to Alice or Bob? The answer is it requires an oracle mechanism 
// to fetch accurate match outcomes offchain and deliver it to the blockchain in a secure 
// and reliable manner.



// Blockchains obtain their most valuable properties like strong consensus on the validity of user transactions, 
// prevention of double-spending attacks, and mitigation of network downtime. Securely interoperating with 
// offchain systems from a blockchain requires an additional piece of infrastructure known as an “oracle” 
// to bridge the two environments.