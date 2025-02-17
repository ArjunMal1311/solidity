// Account Abstraction

// Normally we require a private key to sign transaction, this means if we loose our private key, we are screwed
// Every transaction requires gas fees, which mean you always need some ETH

// Account Abstraction changes this by letting smart contracts act as wallets, instead of private keys
// requiring multiple approvals before a transaction goes through
// allowing someone else to pay your gas fees
// spending limits


// In traditional Ethereum:
// 1. You sign a transaction with Metamask (or another wallet).
// 2. The transaction goes directly to an Ethereum node.
// 3. The node validates and adds it to the blockchain.


// With account abstraction (ERC-4337):
// 1. Instead of signing with a private key, you sign with something else (like Google, biometrics, or multi-signature rules).
// 2. Instead of sending it directly to the blockchain, you send it to an alternative mempool (a temporary storage before it reaches the blockchain).
// 3. The alt mempool nodes check and validate your transaction.
// 4. These nodes then send your transaction to a special smart contract called Entrypoint.
// 5. Entrypoint routes your transaction to your smart contract wallet (instead of a normal Ethereum account).

// Why is This Cool?
// 1. No more relying only on private keys. You can set up social recovery (e.g., if three friends approve, your wallet can be restored).
// 2. No need to always have ETH. A system called Paymaster lets someone else (e.g., an app or a company) sponsor your transactions.
// 3. More security and flexibility. You can define custom rules in your smart contract wallet.



// Ethereum vs. zkSync
// Ethereum doesn’t have account abstraction built in, so ERC-4337 simulates it using Entrypoint and alt mempools.
// zkSync has account abstraction built in, so every account is automatically a smart contract. This removes the need for the extra mempool step.

