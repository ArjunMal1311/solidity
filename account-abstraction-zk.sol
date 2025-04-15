// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * Lifecycle of a type 113 (0x71) transaction
 * msg.sender is the bootloader system contract
 *
 * Phase 1 Validation
 * 1. The user sends the transaction to the "zkSync API client" (sort of a "light node")
 * 2. The zkSync API client checks to see the the nonce is unique by querying the NonceHolder system contract
 * 3. The zkSync API client calls validateTransaction, which MUST update the nonce
 * 4. The zkSync API client checks the nonce is updated
 * 5. The zkSync API client calls payForTransaction, or prepareForPaymaster & validateAndPayForPaymasterTransaction
 * 6. The zkSync API client verifies that the bootloader gets paid
 *
 * Phase 2 Execution
 * 7. The zkSync API client passes the validated transaction to the main node / sequencer (as of today, they are the same)
 * 8. The main node calls executeTransaction
 * 9. If a paymaster was used, the postTransaction is called
 */



// What's happening
// Transaction 113 or (0x71)

// unlike ethereum we are sending transaction to an alt group of nodes which sends to ethereum node
// on ZK sync we say this is an account abstraction transaction and you can send it directly to normal zk zync nodes


// when you do that a zk sync system contract is called bootloader takes ownership of the transaction
// zk sync has group of called system contracts, special contracts with very unique priveleges 

// one of them is nonce holder smart contract which is a contract that holds the nonce for the account (mapping of nonce to account all)
// calls validateTransaction and then calls executeTransaction





// * Account Abstraction is called Type 113

// * No alt-mempool, transaction go directly to ZKsync nodes

// * Transaction lifecycle is run by system contracts

// * A system contract called `bootloader` becomes the owner/sender

// * NonceHolder contains mapping off all nonces and addresses

// * The two phases of the lifecycle are validation and execution

//   * **Phase 1: Validation**

//   1. The user sends the transaction to the "ZKsync API client" (sort of a "light node").
//   2. The ZKsync API client checks to see that the nonce is unique by querying the `NonceHolder` system contract.
//   3. The ZKsync API client calls `validateTransaction`, which MUST update the nonce.
//   4. The ZKsync API client checks the nonce is updated.
//   5. The ZKsync API client calls `payForTransaction`, or `prepareForPaymaster` & `validateAndPayForPaymasterTransaction`.
//   6. The ZKsync API client verifies that the bootloader gets paid.

//   * **Phase 2: Execution**

//   1. The ZKsync API client passes the validated transaction to the main node / sequencer (as of today, they are the same).
//   2. The main node calls `executeTransaction`.
//   3. If a paymaster was used, the `postTransaction` is called.

// * Additionally, we can have an outside sender who is not the `bootloader`.
//   * We will need to make it run through the same validation phase as the `bootloader` would have.