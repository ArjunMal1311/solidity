// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Smart contracts are a set of instructions executed in a decentralized way without the need for any centralized or third party intermediary
// Blockchain Oracles are services that provide real-world data to smart contracts
// Hybrid Smart Contracts are smart contracts that use both on-chain and off-chain data


// L2 or Layer 2 is a technology that solves an issue that most blockchains see where thye
// dont scale very well, it solves scalability issue

// Polygon chain and we have Polygon ZK EVM L2
// These are different

// Transaction Fees ->  Gas Price * Gas Used
// Gas Fees -> variable costs paid to miners/validators based on computational effort

// Sending 1 ETH to a friend
// Gas Fee: The network charges 0.002 ETH (~$7) for processing.
// Transaction Fee: The total cost you pay is 1.002 ETH (1 ETH + 0.002 ETH gas)


// `Consensus` is defined as the mechanism used to reach an agreement on the state or a single value on the blockchain especially in a decentralized system.
// Sybil resistance is a blockchain's ability to defend against users creating a large number of pseudo-anonymous identities to gain a disproportionately advantageous influence over said system.


// there are two primary types of sybil resistance:
// * Proof of Work
// * Proof of Stake

// A `chain selection rule` is implemented as a means to determine which blockchain is 
// the _real_ blockchain. Bitcoin (and prior to the merge, Ethereum), both use something 
// called `Nakamoto Consensus`. This is a combination of Proof of Work (Etherum has since switched to Proof of Stake) and the `longest chain rule`.
// In the `longest chain rule`, the decentralized network decides that whichever chain has 
// the most number of blocks will be the valid, or _real_ blockchain. When we saw 
// `block confirmations` in Etherscan earlier, this was representing the number of 
// blocks ahead of our transaction in the longest chain.

// The first node to solve the problem gets paid the transaction fees accumulated in the block they mine. 
// In addition to this, miners are also paid a `block reward`, the `block reward` is given by the blockchain itself.



// There are two major types of attacks that exist in the blockchain space.

// * Sybil Attack - When a user creates a number of pseudo-anonymous accounts to try to influence a network.
// * 51% attack - Occurs when a single entity possesses both the longest chain and majority network control. This would allow the entity to `fork` the chain and bring 
// the network onto the entities record of events, effectively allowing them to validate anything.


// Proof of Stake nodes put up some collateral that they are going to behave honestly aka they `stake`. If a node is found to be misbehaving, it's stake is slashed. 
// This serves as a very effective sybil resistance mechanism because for each account, the validator needs to put up more stake and misbehaving risks losing all that collateral.


// `Layer 1` solutions: This refers to base layer blockchain implementations like Bitcoin or Ethereum.
// `Layer 2` solutions: These are applications added on top of a layer one, like [Chainlink](https://chain.link/) or [Arbitrum](https://arbitrum.io/).

// Sepolia is a layer 1 testnet and zkSync is a layer 2 rollup.

// Chainlink is a decentralized oracle network that provides real-world data to smart contracts.
// Its also an eg of L2

// Rollups are a type of Layer 2 solution that are used to increase the scalability of blockchains.
// They work by bundling multiple transactions together and sending them to the layer 1 blockchain as a single transaction.
// This allows for a higher throughput of transactions and lower fees.

// zkSync is a Layer 2 solution that uses zero-knowledge proofs to achieve fast and scalable transactions.



// We have Optimisic Rollups and Zero Knowledge Rollups
// Optimistic Rollups assume that off chain transactions are valid and only challenge them if there is an issue.
// Zero Knowledge Rollups use zero-knowledge proofs to achieve fast and scalable transactions.

// slashing is when a validator is punished for misbehavior.

// Simply in Rollups we are bundling multiple transactions together and sending them to the layer 1 blockchain as a single transaction.
// Rollups enhance Ethereum's scalability by processing transactions off-chain, bundling them, and submitting them back to Ethereum 
// with validity proofs. This method maintains the security and decentralization of L1 while significantly increasing transaction throughput.

// Role of a **sequencer** is crucial for ordering and bundling transactions. Sequencers are operators that are responsible for organizing how transactions are processed. 
// In many roll-up solutions, sequencers are centralized, controlled by a single entity.

// Rollup stage - A categorization system used to describe the decentralization and maturity of a rollup.

// ### Rollup Stages
// 1. **Stage 0**: In this initial stage, the rollup's governance is largely in the hands of the operators and a security council, ensuring that critical decisions and actions are overseen by a _trusted group_. The open-source software allows for the reconstruction of the state from L1 data, ensuring transparency and accessibility. Users in this stage have an exit mechanism that allows them to leave the rollup within seven days. However, this often requires actions from an entity/operator.
// 2. **Stage 1**: In this stage, governance evolves to be managed by _smart contracts_, although the _security council_ still plays an important role (e.g. solving bugs). At this stage, the proof system becomes fully functional, enabling decentralized submission of validity proofs. The exit mechanism is improved, allowing users to exit independently without needing operator coordination.
// 3. **Stage 2**: In this final stage, the rollup achieves full decentralization with governance entirely managed by smart contracts, removing the need for operators or council interventions in everyday operations. The proof system at this stage is permissionless and the exit mechanism is also fully decentralized. The security council's role is now strictly limited to addressing any errors that occur on-chain, ensuring that the system remains fair without being overly reliant on centralized entities.


// Compiling a contract -> It converts the Solidity code into bytecode and ABI that can be understood and executed by the Ethereum Virtual Machine (EVM).

// View functions dont allow changing the state of variables in the function (contract) whereas 
// pure functions dont allow reading or changing the state of variables in the function (contract)


// ### Data Locations

// Solidity can store data in **six** different locations. In this lesson, we will focus on the first three:

// 1. Calldata
// 2. Memory
// 3. Storage
// 4. Stack
// 5. Code
// 6. Logs


// In Solidity, `calldata` and `memory` are temporary storage locations for variables during function execution. 
// `calldata` is read-only, used for function inputs that can't be modified. In contrast, `memory` allows for read-write access, 
// letting variables be changed within the function. To modify `calldata` variables, they must first be loaded into `memory`.

// Variables stored in `storage` are persistent on the blockchain, retaining their values between function calls and transactions.

// virtual is used in a parent contract to allow a function to be overridden, while override is used in a child contract to provide a new implementation for that function.

// 1 Ether = 1e9 Gwei = 1e18 Wei



// During a **value** transfer, a transaction will contain the following fields:

// Nonce: transaction counter for the account
// Gas price (wei): maximum price that the sender is willing to pay _per unit of gas_
// Gas Limit: maximum amount of gas the sender is willing to use for the transaction. A common value could be around 21000.
// To: _recipient's address_
// Value (Wei): amount of cryptocurrency to be transferred to the recipient
// Data: 🫙 _empty_
// v,r,s: components of the transaction signature. They prove that the transaction is authorised by the sender.


// `msg.sender` is a global variable that contains the address of the account that called the current function.
// `msg.value` is a global variable that contains the amount of Ether sent with the transaction.
// `msg.data` is a global variable that contains the data sent with the transaction.

// During a _**contract interaction transaction**_, it will instead be populated with:

// Nonce: transaction counter for the account
// Gas price (wei): maximum price that the sender is willing to pay _per unit of gas_
// Gas Limit: maximum amount of gas the sender is willing to use for the transaction. A common value could be around 21000.
// To: _address the transaction is sent to (e.g. smart contract)_
// Value (Wei): amount of cryptocurrency to be transferred to the recipient
// Data: 📦 _the content to send to the_ _**To**_ _address_, e.g. a function and its parameters.
// v,r,s: components of the transaction signature. They prove that the transaction is authorised by the sender.


// To interact with any external contract, you need the contract's _address_ and _ABI_ (Application Binary Interface). 
// Think of the `address` as a _house number_ that identifies the specific contract on the blockchain, while the `ABI` 
// serves as a _manual_ that explains how to interact with the contract.

// Like `transfer`, `send` also has a gas limit of 2300. If the gas limit is reached, it will not revert 
// the transaction but return a boolean value (`true` or `false`) to indicate the success or failure of the transaction. 
// It is the developer's responsibility to handle failure correctly, and it's good practice to trigger a **revert** condition if the `send` returns `false`.


// Using the `constant` keyword can save approximately 19,000 gas, which is close to the cost of sending ETH between two accounts.

// The immutable keyword allows values to be set at runtime, while the constant keyword requires values to be set at compile time.
// The value is not known at compile-time, but must be assigned inside the constructor. (immutable)