// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


// DAO stands for Decentralized Autonomous Organization, this is defined as:
// Any group that is governed by a transparent set of rules found on a blockchain or smart contract.


// Decentralized voting/governance is the cornerstone of how these systems operate!



// E.g.
// Compound
// is a borrowing and lending protocol which allows users to borrow and lend digital assets. 
// In Compound, when a decision arises such as listing a new token, or changing interest rates, 
// the decision is handled through their governance mechanism, their DAO.



// Often this is handled via an ERC20 or an NFT of some kind, but this runs the risk of being _less_ fair 
// if the tokens are more available to the wealthy than others. This is not dissimilar to Web2 companies 
// and how the voting power of company shares works.


// One methodology is the "Skin in the Game" method whereby voting records are recording and 
// negative outcomes result in tokens/voting power being lost.


// A third approach is something called "Proof of Personhood Participation" and while potentially ideal, 
// isn't something with a sound implementation yet. The idea would be a method by which someone can be verified as 
// being a single human entity, but the logics of this are difficult and rub up against anonymity. 
// Some projects like WorldCoin are trying to find solutions here!



// Handled via smart contract, votes are placed by calling functions to this contract. A major drawback of this is the gas 
// costs associated with placing this vote transaction. Even small costs in gas can be enough to dissuade participation, 
// and that's to say nothing of transactions which happen to be expensive due to congestion or poor code.


// or we go could off chain, just sign a transaction and vote in decentralized way without spending gas

// Transactions can actually be signed without being sent to the blockchain. What this means is a protocol could take a 
// bunch of signed transactions, uploaded to a decentralized database (like IPFS), calculate the votes and then batch submit 
// them to the blockchain, maybe even leveraging an oracle to ensure decentrality. This can reduce voting costs by up to 99%!