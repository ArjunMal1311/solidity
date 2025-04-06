// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// Events are a way for smart contracts to communicate with the outside world, primarily with the front-end applications that interact 
// with these contracts. Events are logs that the Ethereum Virtual Machine (EVM) stores in a special data structure known as the blockchain log. 
// These logs can be efficiently accessed and filtered by external applications, such as dApps (decentralized applications) or off-chain services. 
// The logs can also be accessed from the blockchain nodes. Each emitted event is tied up to the smart contract that emitted it.

// Events are used to print information to logging structure
// in a way of more gas efficient way

// event EnteredRaffle(address indexed player);

// function enterRaffle() external payable {
//     if(msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
//     s_players.push(payable(msg.sender));
//     emit EnteredRaffle(msg.sender);

// }


// there are 2 types of events
// 1. indexed
// 2. non-indexed

// indexed is used to filter the event, faster to search also known as topics
// non-indexed is used to store the event

// how does the event look like?
// we have address of the contract, and account the event is emitted from
// indexed data, data

// non indexed data is the data that is not indexed, takes less gas and slower to search