// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Blockchain
// Blockchain is a distributed ledger that is used to record transactions between two parties efficiently and in a secure way.

// Bitcoin was the first successful blockchain
// Work
// Proof of Work - Security
// Mining Rewards - Financial Incentive
// Public Key Cryptography - Authentication
// Linked Data Structure - Chronology
// Peer to Peer Network - Permissionless

// Cryptographic Hash Function
// -> Deterministic
// -> Pseudorandom
// -> Oneway
// -> Fast to compute
// -> Collision Resistance

// E.g. SHA-256


// This is how we hash a message (transaction)
function hashMessage(message) {
    const bytes = utf8ToBytes(message);
    const hash = keccak256(bytes); 

    return hash;
}


// Signing using private key
const PRIVATE_KEY = "6b911fd37cdf5c81d4c0adb1ab7fa822ed253ab0ad9aa18d77257c88b29b718e";

async function signMessage(msg) {
    const bytes = utf8ToBytes(msg);
    const hash = keccak256(bytes); 
    return secp.sign(hash, PRIVATE_KEY, { recovered: true });    
}


// Now you can see how a blockchain node is able to authenticate transactions! 
async function recoverKey(message, signature, recoveryBit) {
    // First, hash the message using your hashMessage function
    const messageHash = await hashMessage(message);

    // The recoverPublicKey function requires a recoveryBit as an integer (0 or 1)
    const recoveredPublicKey = secp.recoverPublicKey(messageHash, signature, recoveryBit);

    return recoveredPublicKey;
}


// Getting the Ethereum Address from the Public Key
function getAddress(publicKey) {
    // Step 1: Slice off the first byte
    const publicKeyWithoutPrefix = publicKey.slice(1);

    // Step 2: Keccak256 hash of the public key
    const hash = keccak256(publicKeyWithoutPrefix);

    // Step 3: Take the last 20 bytes of the hash
    const address = hash.slice(-20);

    return address;
}


// First step, you'll need to take the first byte off the public key. 
// The first byte indicates the format of the key, whether it is in the compressed format or not. 
// The publicKey will be a Uint8Array so you can use the slice method to slice off the first byte.

// Next, take the keccak hash of the rest of the public key.

// Finally, take the last 20 bytes of the keccak hash and return this. Once again, you can make use of the slice method.

// ------------------------------------------------------------------------------------------------
// Blockchain consensus typically means at least 51% of nodes are in agreement over the current global state of the network. Consensus mechanisms end up simply being rules that a distributed + decentralized blockchain network follows in order to stay in agreement over what is considered valid. Remember that consensus mechanisms are inter-changeable and there are many out there that we have yet to cover, like proof-of-stake.

// The main consensus rules for proof-of-work typically look like religious commandments:

// You cannot double spend.
// The "longest" chain will be the one the rest of the nodes accept as the one "true" chain, determined by a chain's cumulative work. Also known as Nakamoto Consensus.

// ------------------------------------------------------------------------------------------------

// proof-of-work mining algorithm looks like:

// Take current block’s block header, add mempool transactions
// Append a nonce, starting at nonce = 0
// Hash data from #1 and #2
// Check hash versus target difficulty (provided by protocol)
// If hash < target, puzzle is solved! Get rewarded.
// Else, restart process from step #2, but increment nonce


// ------------------------------------------------------------------------------------------------

// Mempool
// Users who want to make transactions will broadcast their transactions to the blockchain network. 
// Typically, the miner will take all the transactions with the highest transaction fees from the mempool. Then they'll add them to the block and attempt to find the proof of work.The mempool is a place for miners to keep those transactions before adding them to a block.

const mempool = [];
const blocks = [];

function addTransaction(transaction) {
    mempool.push(transaction);
}

function mine() {
    let transactions = [];
    while (transactions.length < MAX_TRANSACTIONS && mempool.length > 0) {
        transactions.push(mempool.pop());
    }
    const block = { id: blocks.length, transactions }
    block.nonce = 0;
    let hash;
    while (true) {
        hash = SHA256(JSON.stringify(block)).toString();
        if (BigInt(`0x${hash}`) < TARGET_DIFFICULTY) {
            break;
        }
        block.nonce++;
    }
    blocks.push({ ...block, hash });
}


// Hard hat test
const {assert} = require('chai');
const {addTransaction, mempool} = require('../index');

describe('addTransaction', () => {
    it('should add the transaction to the mempool', () => {
        const transaction = { to: 'bob', sender: 'alice' }
        addTransaction(transaction);
        assert.equal(mempool.length, 1);
        assert.equal(mempool[0], transaction);
    });
});

const { assert } = require('chai');
const { mine, blocks, mempool, addTransaction } = require('../index');
const SHA256 = require('crypto-js/sha256');

const { assert } = require('chai');
const { mine, blocks, mempool, addTransaction, TARGET_DIFFICULTY } = require('../index');
const SHA256 = require('crypto-js/sha256');

describe('mine', () => {
    describe('with 5 mempool transactions', () => {
        before(() => {
            for (let i = 0; i < 5; i++) {
                addTransaction({ sender: 'bob', to: 'alice' });
            }
        });
        describe('after mining', () => {
            before(() => {
                mine();
            });
            it('should add to the blocks', () => {
                assert.equal(blocks.length, 1);
            });
            it('should store the transactions on the block', () => {
                assert.equal(blocks[blocks.length - 1].transactions.length, 5);
            });
            it('should clear the mempool', () => {
                assert.equal(mempool.length, 0);
            });
            it('should have a nonce', () => {
                assert.isDefined(blocks[blocks.length - 1].nonce, "did not find a nonce on the block");
            });
            it('should have a hash lower than the target difficulty', () => {
                const actual = blocks[blocks.length - 1].hash.toString();
                const isLess = BigInt(`0x${actual}`) < TARGET_DIFFICULTY;
                assert(isLess, "expected the hash to be less than the target difficulty");
            });
        });
    });
    describe('with 15 mempool transactions', () => {
        before(() => {
            for (let i = 0; i < 15; i++) {
                addTransaction({ sender: 'bob', to: 'alice' });
            }
        });
        describe('after mining', () => {
            before(() => {
                mine();
            });
            it('should add to the blocks', () => {
                assert.equal(blocks.length, 2);
            });
            it('should store the transactions on the block', () => {
                assert.equal(blocks[blocks.length - 1].transactions.length, 10);
            });
            it('should reduce the mempool to 5', () => {
                assert.equal(mempool.length, 5);
            });
            it('should have a nonce', () => {
                assert.isDefined(blocks[blocks.length - 1].nonce, "did not find a nonce on the block");
            });
            it('should have a hash lower than the target difficulty', () => {
                const actual = blocks[blocks.length - 1].hash.toString();
                const isLess = BigInt(`0x${actual}`) < TARGET_DIFFICULTY;
                assert(isLess, "expected the hash to be less than the target difficulty");
            });
            describe('after mining again', () => {
                before(() => {
                    mine();
                });
                it('should add to the blocks', () => {
                    assert.equal(blocks.length, 3);
                });
                it('should store the transactions on the block', () => {
                    assert.equal(blocks[blocks.length - 1].transactions.length, 5);
                });
                it('should clear the mempool', () => {
                    assert.equal(mempool.length, 0);
                });
                it('should have a nonce', () => {
                    assert.isDefined(blocks[blocks.length - 1].nonce, "did not find a nonce on the block");
                });
                it('should have a hash lower than the target difficulty', () => {
                    const actual = blocks[blocks.length - 1].hash.toString();
                    const isLess = BigInt(`0x${actual}`) < TARGET_DIFFICULTY;
                    assert(isLess, "expected the hash to be less than the target difficulty");
                });
            });
        });
    });
});

// ------------------------------------------------------------------------------------------------

