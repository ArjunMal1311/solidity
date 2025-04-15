// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract AccountAbstraction {
// Account Abstraction is a concept in Ethereum that allows users to create and manage accounts in a more flexible and secure way.


// Why Account Abstraction?
// 1. Users don't need to manage private keys.
// 2. Users don't need to pay gas fees.
// 3. Users don't need to understand blockchain mechanics.
// 4. Users can use familiar authentication methods (e.g., Google, email, or social logins).


// Ethereum implements account abstraction using a smart contract called `EntryPoint.sol`. 
// This contract acts as a gateway for handling user operations and transactions in a more flexible manner.



// STEPS
// 1. ### User Operation (Off Chain) 
// In Ethereum, user operations are first sent off-chain. This means that the initial handling and validation occur outside the main blockchain network, 
// reducing congestion and improving efficiency. In the above example, the user operation is signed with Google and is sent to the alt-mempool, 
// which then sends it to the main blockchain network. The alt mempool is any nodes which are facilitating this operation. So the user is 
// not sending their transaction to the Ethereum nodes.


// 2. ### Transactions and Gas Payments (On-Chain)
// Once validated, the user operations are sent on-chain as transactions. These transactions are executed and gas fees are paid on behalf of the user, 
// directly from their account, by the alt-mempool nodes. This is managed through the `EntryPoint.sol` contract. From here, the user's smart 
// contract essentially becomes their wallet. If a paymaster is not set up, the funds will be deducted from the account. Finally, the contract is deployed to the blockchain.

// 3. ### Entrypoint
// The `EntryPoint.sol` contract also allows for optional add-ons, such as a Signature Aggregator and a Paymaster. These add-ons can be used to further 
// optimize gas fees and improve user experience.
// Signature Aggregator -> define multiple signatures to be aggregated and verified. This means that other users can sign transactions on the same wallet 
// or multi-sign logic can be added, such as requiring multiple signatures before authorizing transactions.

// Paymaster -> Another optional component is the pay master. It handles gas payments, allowing users to pay for transactions in various ways, not limited to the native cryptocurrency.


// In ZKsync, the alt-mempool nodes are also the ZKsync nodes. This means that sending the transaction to the alt-mempool can be skipped. The reason ZKsync can do this is because every 
// account (e.g., MetaMask) is by default a smart contract account as it is automatically connected to a [DefaultAccount.sol](https://github.com/matter-labs/era-contracts/blob/main/system-contracts/contracts/DefaultAccount.sol).



// The traditional Ethereum transactions consists of first the signing of the transaction by the sender's private key, and then sending it to an Ethereum node. 
// The node verifies that the signature is valid and if so, adds it to its mempool for later inclusion in a block. 


/*

OFF-CHAIN                                                                  ON-CHAIN
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

   ??? Signs Data                Alt-Mempool Nodes                  EntryPoint.sol             Your Account              Blockchain
+----------------+           +-----------------------+         +--------------------+     +-------------------+     +------------+
| Google / OAuth | ───────▶  |  Custom Bundler       | ─────▶  |  (EVM) EntryPoint  | ──▶ | MyNewAccount.sol  | ──▶ | Block data |
| signs UserOp   |           | (Alternative Mempool) |         | Signature Aggregator?     | Handles logic     |     | Final Tx   |
+----------------+           +-----------------------+         +--------------------+     +-------------------+     +------------+
        │                             │                                ▲                         │
        │                             ▼                                │                         ▼
        │                   +--------------------+                    │               +------------------+
        └────────────────▶  | UserOperation Data | ───────────────────┘               |   Paymaster.sol   |
                            +--------------------+                                    |   (optional)      |
                                                                                      +------------------+

LEGEND:
- UserOperation = a meta-transaction object
- Google = identity provider signs the data
- Alt-Mempool = bundlers who package UserOps into txs
- EntryPoint.sol = core contract that verifies and processes UserOps
- MyNewAccount.sol = user's smart contract wallet
- Paymaster.sol = optional sponsor to pay for gas
- Blockchain = final inclusion

*/


// IN SIMPLE TERMS
// User signs user operation -> Bundler Bundles Alt-Mempool Nodes -> EntryPoint -> our contract (myNewAccount.sol) -> Hey Transaction is valid -> if not valid it will revert and if its valid alt mempool nodes will be able to send transactions to the blockchain
// Entrypoint calls the paymaster


// I sign a transaction (really, a UserOperation) – this includes my intention (like transferring tokens or calling a contract).
// This UserOp is picked up and sent to the EntryPoint.sol smart contract.
// EntryPoint then contacts MyAccount.sol (my smart wallet) and calls its validateUserOp() function.
// If MyAccount.sol says ✅ (signature valid, enough gas, etc.), then EntryPoint executes the operation.
// If successful, the result (like transfer or function call) is committed on-chain.


// also in validateUserOp we can have PackedUserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds and also other thing
// so if there's missingAccountFunds, then we can have a paymaster to pay for the gas or we can pay ourselves

struct PackedUserOperation {
    address sender;
    uint256 nonce;
    bytes initCode;
    bytes callData;
    bytes32 accountGasLimits;
    uint256 preVerificationGas;
    bytes32 gasFees;
    bytes paymasterAndData;
    bytes signature;
}


// We are using Ownable in the contracts to make sure that the account is owned by the user

function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash) internal view returns (uint256 validationData) {
   bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
   address signer = ECDSA.recover(ethSignedMessageHash, userOp.signature);
   if (signer != owner()) {
         return SIG_VALIDATION_FAILED;
   }
   
   return SIG_VALIDATION_SUCCESS;
}

// we are converting the userOpHash to an ethSignedMessageHash and then we are recovering the signer from the signature
// we will check signer if it is the owner of the account (ownable thing)




// Also when handling we can do something like only EntryPoint address can interact with the contract
// checkout abstraction/src/ethereum/MinimalAccount.sol



// external function called `execute` : It will pass an address for the destination, uint256 for eth, and bytes calldata for ABI encoded function data
// execute() function is what actually performs the user’s intended action, like sending eth, calling another contract etc..



}