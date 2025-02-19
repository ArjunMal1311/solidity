// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// stable coin is a cryptocurrency whose buying power stays relatively the same like dollar fluctuates less
// than bitcoin

// Categories of stable coin
// 1. Relatively stability (pegged / anchored or floating)
// 2. Stability Method (Governed or algorithmic)
// 3. Collateral Type (Endogenous or Exogenous)

// Relative stability like these coins are pegged on US dollar so their movement depends on the movement of US dollar
// Like USDC for every USDC minted there is equivalent worth of US dollar in bank account
// so we can swap both of them

// Stability method
// depends on who is minting or burning the stable coins, they are thereby kinda centralized
// USDC are governed stable coins

// floating - floating exchange rate system, the value of a currency is determined by the market forces of supply and demand in the foreign exchange market.
// In a pegged exchange rate system, a country's currency is tied, or "pegged," to the value of another currency (often a major one like the U.S. Dollar) or a basket of currencies.

// Algorithmic stable coins use a transparent math equation or set of code to mint and burn tokens
// governed stable coins mint and burn token via human intervention

// If the stable coin fails does the underlying collateral also fail ===> Endogenous
// If not ====> Exogenous

// If USDC fails will US dollar also fail noooo then its exogenous
// But if US dollar fails then Luna which is a crypto fails its endogenous 

// collateral refers to the assets (such as fiat currency, cryptocurrencies, or commodities) that are held in reserve to back the value of a stablecoin.
// You can only have a stablecoin marketcap that is high or higher than that of all your collateral
// If you are backing a stablecoin with collateral (like fiat currency, crypto, etc.), the value of your collateral must equal or exceed the value of the stablecoins that are issued.

// Exogenously collaterized stablecoins
// type of stablecoin that does not rely on external collateral (like fiat money or cryptocurrency reserves) to maintain its value. Instead, they use internal mechanisms within their own ecosystem to maintain 
// price stability. These stablecoins typically rely on algorithms or smart contracts to manage their supply and demand, adjusting the number of coins in circulation to keep the price stable.

// suppose our stable coin is pegged with gold then anytime we can exchange it with the bank
// like give coins take gold and vice versa
// e.g. is exogenously collaterized with gold pegged to its price and governed by us
// burn it when user collects the gold

// now we are moving from this to endogenously 

// die is pegged, algorithmic and exogenously collateral stable coin
// pegged to ETH
