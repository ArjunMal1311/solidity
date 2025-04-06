// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Anvil is a local blockchain network that is used to test and develop smart contracts.

// In scripts
// contract DeploySimpleStorage is Script {
//     function run() external returns (SimpleStorage) {
//         vm.startBroadcast();

//         SimpleStorage simpleStorage = new SimpleStorage();

//         vm.stopBroadcast();
//         return simpleStorage;
//     }
// }

// `vm.startBroadcast` indicates the starting point for the list of transactions that get to be sent to the `RPC URL`;
// Similarly, `vm.stopBroadcast` indicates the ending point of the list of transactions that get to be sent to the `RPC URL`;

// forge script script/DeploySimpleStorage.s.sol

// If we didn't pass an RPC URL, where did this deploy to?
// If the RPC URL is not specified, Foundry automatically launches an Anvil instance, runs your script (in our case deployed the contract) and then terminates the Anvil instance.


// Is it deployed now?
// Answer: No, the output indicates this was a simulation. But, we got a new folder out of this, the `broadcast` folder contains information about different script runs in case we forget details.
// Hit the up arrow key and add `--broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80` at the end.



// BROADCAST FOLDER
// Foundry saves all your blockchain interactions here. 
// The `dry-run` folder is used for interactions you made when you didn't have a blockchain 
// running (remember that time when we deployed our contract without specifying an `--rpc-url`). 
// Moreover, the recordings here are separated by `chainId`



// "transaction": {
//         "from": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
//         "to": null,
//         "gas": "0x714e1",
//         "value": "0x0",
//         "input": "0x608060...c63430008130033",
//         "nonce": "0x0",
//         "chainId": "0x7a69",
//         "accessList": null,
//         "type": null

//       }


// * `from` is self-explanatory, it's the address we used to sign the transaction;
// * `to` is the recipient, in our case is null or address(0), this is the standard destination for when new smart contracts are deployed;
// * `gas` is the amount of gas spent. You will see the hex value `0x714e1` (or any other value represented in hex format);
// * `value` is the transaction value, or the amount of ETH we are sending over. Given that this transaction was made to deploy a contract, the value here is `0x0` or `0`, but we could have specified a value and that would have been the initial balance of the newly deployed contract;
// * `data` in this case is the contract deployment code and the contract code. In the excerpt above this was truncated;
// * `nonce` is a unique identifier assigned to each transaction sent from a specific account. The nonce is used to ensure that each transaction is processed only once and to prevent replay attacks. `nonce` is incremented with every single transaction;
// * `accessList` is a feature of Ethereum to optimize the gas cost of transactions. It contains a list of addresses and associated storage keys that the transaction is likely to access, allowing the EVM to more efficiently compute the gas cost of storage access during the transaction's execution;

// There are other values that play an important part that weren't presented in that list, namely the `v`, `r`, and `s`. These are components of a transaction's signature, which are used to validate the authenticity and integrity of the transaction.
// Whenever we send a transaction over the blockchain there's a signature happening, that's where we use our `private key`.
// **Important:** Every time you change the state of the blockchain you do it using a transaction. The thing that indicates the change is the `data` field of a transaction.



// Act with actual gas considerdation since anvil chain gas price is 0
// uint gasStart = gasleft();
// vm.prank(fundMe.getOwner());
// fundMe.withdraw();
// uint gasEnd = gasleft();
// console.log("Gas used:", (gasStart - gasEnd) * tx.gasprice);