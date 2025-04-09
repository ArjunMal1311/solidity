// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// a rebase token is a type of cryptocurrency where the total circulating supply isn't fixed or changed only through typical minting/burning events
// Instead, its supply adjusts automatically based on rules defined within its underlying smart contract algorithm

// The key difference between rebase tokens and standard cryptocurrencies lies in how they respond to value changes
// In a standard token, the supply remains constant, and the value of each token is determined by market demand
// In a rebase token, the supply adjusts automatically based on predefined rules, which can cause the value of each token to fluctuate


// 1. **Rewards Rebase Tokens:** These are commonly found in DeFi protocols, especially lending and borrowing platforms. 
// The token balance increases over time, representing the yield or interest earned by the holder. 
// The rebase mechanism automatically distributes these earnings by increasing the number of tokens in each holder's wallet.

// 2. **Stable Value Tokens:** This type aims to maintain a stable price, often pegged to a fiat currency like the US dollar. 
// The protocol's algorithm automatically increases or decreases the total token supply in response to market price fluctuations, 
// attempting to push the price back towards its target peg. If the price is above the peg, supply increases (positive rebase) 
// to reduce scarcity; if below the peg, supply decreases (negative rebase) to increase scarcity.


// Consider having 1000 tokens of a specific rebase crypto
// protocol inititates a positive rebase of 10%

// perhaps to distribute the interest earned across all holders
// after the rebase event is done we can see 1100 tokens in our wallet
// but the percentage ownership of total token supply remains exactly the same as rebase applies proportionally to all the stakeholders

// Prominent real life e.g. is aUSDC, aDAI, aETH, when you deposit an asset USDC into aave lending pool you recieve corresponding amount of aTokens
// in this case aUSDC, these tokens represent your claim on deposited assets plus interest they generate over time

// unlike ERC20 tokens where balanceOf function returns a fixed value, here balanceOf function returns a dynamic value
// Suppose you deposit 1000 USDC into Aave when the annual interest rate is 5%
// After exactly one year, if you check your aUSDC balance, it will have automatically increased (rebased) to 1050 aUSDC

// representing your initial deposit plus the 50 USDC earned in interest. You can then withdraw 1050 USDC by redeeming your 1050 aUSDC


// TLDR;
// You deposit 1000 USDC into Aave.
// Aave gives you 1000 aUSDC.
// The interest rate is 10% annually.
// After one year, your aUSDC balance will automatically show 1100.
// You didn't have to claim interest; your balance grew because the token itself rebased.


// This is not minting new tokens for you manually—it's your balance increasing algorithmically as the protocol distributes yield.


// What makes it a rebase?
// Your wallet balance increases over time.
// But you still own the same percentage of the pool.
// All aUSDC holders get a proportional increase—this is reward-based rebase in action.