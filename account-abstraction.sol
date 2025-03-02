// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Account Abstraction is a concept in Ethereum that allows users to create and manage accounts in a more flexible and secure way.

// Traditional Web3
// 1. Users must download and set up a wallet (e.g., MetaMask).
// 2. They need to acquire gas fees (cryptocurrency) to perform transactions.
// 3. They manually approve transactions, which involves understanding gas fees and blockchain mechanics.
// 4. This creates a high-friction experience, making onboarding difficult for new users.



// Account Abstraction with Gasless Transactions
// 1. Users still need a wallet but don't have to pay gas fees themselves.
// 2. Instead of sending a transaction directly, they sign a user operation, a new object type.
// 3. A third party (relayer) can cover the gas costs, reducing onboarding friction.


// Seamless Web2-like Experience
// 1. Users log in using familiar authentication methods (e.g., Google, email, or social logins).
// 2. They don’t need to manually manage private keys for transactions.
// 3. Gas fees are covered, making interactions as simple as clicking a button.
// 4. The experience is smooth, invisible, and more intuitive for mainstream adoption.

// the user's private key is still used, but in a way that is abstracted away. 
// Instead of directly signing transactions, it authorizes a smart contract (smart contract wallet) that handles transactions on behalf of the user.



// 2 Types of Accounts
// 1. Externally Owned Account -> private/public key pair, can initiate transactions
// 2. Smart Contract -> blockchain program, cannot initiate transactions, can only be called by other accounts


// if we can merge the 2 types of accounts, we can create a new type of account that can initiate transactions and be called by other accounts.


// ERC 4337
// 5 Roles of EIP 4337
// 1. User -> User holds a crypto key just like regular wallets but instead of submitting a transaction directly user signs a user operation and submits it off chain
// 2. Bundler -> Acts as EOA and collects multiple multiple user operations signs them and submits them on chain as actual transactions
// 3. Entry Point -> special smart contract that calculates gas fees before executing transaction
// 4. Paymaster -> 3rd party such as sponsor to cover gas fees for the user
// 5. Smart Contract Account -> Holds funds and executes transactions only when the user signs a valid user operation

// Transactions with EIP-4337 (Account Abstraction)
// 1. The User signs a "User Operation" (not an Ethereum transaction).
// 2. The Bundler collects multiple User Operations and submits them as a single Ethereum transaction.
// 3. The Entry Point ensures gas is covered, either from the Smart Contract Account or via a Paymaster.
// 4. The Smart Contract Account then executes the intended action (e.g., a token swap on Uniswap).



// User (key) -> Bundler (EOA) -> Entry Point -> Smart Contract Account -> State Changes
//                                   or
//                                paymaster

// EXAMPLE
// Step 1: Alice Creates a UserOperation
//      Instead of a normal transaction, Alice's smart contract wallet (like Safe or ZeroDev) creates a UserOperation, which contains:
//      a. sender: Alice’s smart contract wallet.
//      b. callData: The function call to buy the NFT (e.g., "Buy NFT ID #123").
//      c. nonce: A unique number to prevent replay attacks.
//      d. paymasterData: Specifies a Paymaster that will pay gas fees.
//      e. signature: Alice signs this operation using her wallet.

//      Her wallet doesn’t need ETH to sign this.



// Step 2: The Bundler Collects UserOperations
//      The bundler scans the mempool for UserOperations.
//      It finds Alice’s request and simulates the transaction to check:
//          a. Is the operation valid?
//          b. Does the Paymaster agree to pay gas fees?
//      If everything is fine, the bundler packages Alice’s operation along with other users’ operations into a single transaction.



// Step 3: The EntryPoint Contract Processes the Operation
//      The bundler sends the packaged transactions to the EntryPoint contract.
//      The EntryPoint contract:
//          a. Verifies Alice’s UserOperation.
//          b. Checks if the Paymaster has enough funds to cover gas fees.
//          c. Calls Alice’s smart contract wallet to execute the NFT purchase.



// Step 4: Alice’s Smart Contract Wallet Executes the Purchase
//      The smart contract wallet receives the request from EntryPoint.
//      It interacts with OpenSea’s smart contract to buy the NFT.
//      The NFT is transferred to Alice’s wallet.



// Step 5: Gas Fees Are Paid by the Paymaster
//      The Paymaster (e.g., OpenSea, a sponsor, or a gas-relayer service) covers the gas cost.
//      The Paymaster reimburses the bundler for processing the transaction.
//      Alice doesn’t need to hold any ETH!


// Final Outcome
// ✅ Alice buys the NFT without needing ETH in her wallet.
// ✅ The Paymaster covers gas fees, making the experience smooth.
// ✅ The bundler processes multiple transactions in one batch, reducing network congestion.




// EntryPoint
// FOREACH USEROP
// 1. Account Validation
// 2. Paymaster Approval
// 3. Account -> State Changes
// 4. Paymaster postOp

// All inside EVM