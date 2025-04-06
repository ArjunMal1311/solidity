// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Stable coins is a non volatile crypto asset whose buying power fluctuates little to very little to rest of market


// Society requires an everyday stable currency in order to fulfill the 3 functions of money:
// 1. Storage of Value
// 2. Unit of Account
// 3. Medium of Exchange


// categorize stablecoins as:
// 1. Relative Stability - Pegged/Anchored or Floating
// 2. Stability Method - Governed or Algorithmic
// 3. Collateral Type - Endogenous or Exogenous


// **Relative Stability:** Something is only stable relative to its value in something else. The most common type of `stablecoins` are `pegged` or `anchored` `stablecoins`. 
// Their value is determined by their `anchor` to another asset such as the US Dollar. 
// `Tether`, `DAI` and `USDC` are examples of stablecoins which are pegged to USD.


// * **Governed:** This denotes an entity which ultimately decides if stablecoins in a protocol should be minted or burned. This could something _very_ centralized and controller, like a single person, or more democratic such as governed via DAO. Governed stablecoins are generally considered to be quite centralized. This can be tempered by DAO participations, but we'll get more into how that affects things later
//   * Examples of governed stablecoins include:
//     * USDC
//     * Tether
//     * USDT
// * **Algorithmic:** Conversely, algorithmic stablecoins maintain their stability through a permissionless algorithm with **no human intervention**. I would consider a stablecoin like DAI as being an example of an algorithmic stablecoin for this reason. All an algorithmic stablecoin is, is one which the minting and burning is dictated by autonomous code.
//   * Examples of algorithmic stablecoins include:
//     * DAI
//     * FRAX
//     * RAI
//     * UST - RIP


// * **Exogenous:** Collateral which originates from outside of a protocol.
// * **Endogenous:** Collateral which originates from within a protocol



// _**If the stablecoin fails, does the underlying collateral also fail?**_
// Yes == Endogenous
// No == Exogenous

// DAI is:
// * Pegged
// * Algorithmic
// * Exogenously Collateralized
// DAI is one of the most influential DeFi projects ever created.


