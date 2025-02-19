// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// What's happening
// Transaction 113 or (0x71)

// unlike ethereum we are sending transaction to an alt group of nodes which sends to ethereum node
// on ZK sync we say this is an account abstraction transaction and you can send it directly to normal zk zync nodes


// when you do that a zk sync system contract is called bootloader takes ownership of the transaction
// zk sync has group of called system contracts, special contracts with very unique priveleges 

// one of them is nonce holder smart contract which is a contract that holds the nonce for the account (mapping of nonce to account all)
// calls validateTransaction and then calls executeTransaction