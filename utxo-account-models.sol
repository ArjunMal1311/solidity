// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Bitcoin uses the UTXO model to keep track of user balances. Ethereum and other EVM chains use the account model to keep track of user balances.


// What is the purpose of a transaction?
// To change some user state! If Alice sends Bob 5 $DAI, Alice's $DAI balance should go -5, Bob's should go +5. Alice's transaction 
// is responsible for changing the state of their balances. Changing state is extremely important in 
// blockchains (which are typically transaction-based networks!)



// What does a transaction look like in an account-based model?
// Alice has $60 total balance
// Bob has $20 total balance
// Bob sends Alice $5
// Bob's balance is subtracted $5, if the remaining balance is greater then 0, proceed, else revert
// Alice balance is summed $5
// The ledger is marked in both ends to update total balances and that is the end of the transaction in an account-based model.



// Ethereum uses the account-based model, while Bitcoin uses UTXOs (short for Unspent Transaction Outputs) to keep track of user state/balances.
// The UTXO model differs pretty drastically from the account model. It's a little bit more complex - 
// mainly because it is not a familiar interface like the account model is! Yet it does set up some interesting features...

// What is a UTXO? 🤔**
// Alice sends Bob 5 BTC in the form of a transaction relayed to the Bitcoin network. At this point, if the transaction is 
// valid (Alice has > 5 BTC, Alice owns the relevant private keys and can produce a signature, etc), Alice is signaling an intent to change user state. When the Bitcoin network mines Alice's transaction, 
// Bob is credited with a UTXO worth 5 BTC. This is how the Bitcoin network keeps track of user balances - it keeps a really big long set of UTXOs - outputs out of state-changing transactions that credit users with a certain amount of BTC.
// So when people say: "I own 3 bitcoins", they should really be saying: "I own some UTXOs that allow me to spend 3 bitcoins."



class Transaction {
    constructor(inputUTXOs, outputUTXOs) {
        this.inputUTXOs = inputUTXOs;
        this.outputUTXOs = outputUTXOs;
    }
    execute() {
        const anySpent = this.inputUTXOs.some((x) => x.spent);
        if (anySpent) {
            throw new Error("Cannot include a spent UTXO");
        }

        const inputAmount = this.inputUTXOs.reduce((p, c) => {
            return p + c.amount;
        }, 0);
        const outputAmount = this.outputUTXOs.reduce((p, c) => {
            return p + c.amount;
        }, 0);
        if (inputAmount < outputAmount) {
            throw new Error("Not enough here");
        }

        this.inputUTXOs.forEach((utxo) => {
            utxo.spend();
        });

        this.fee = (inputAmount - outputAmount);
    }
}

module.exports = Transaction;


const { assert } = require('chai');
const Transaction = require('../Transaction');
const TXO = require('../TXO');

describe('Transaction', function () {
    const fromAddress = "1DBS97W3jWw6FnAqdduK1NW6kFo3Aid1N6";
    const toAddress = "12ruWjb4naCME5QhjrQSJuS5disgME22fe";

    describe('with no remainder', () => {
        const txo1 = new TXO(fromAddress, 5);
        const txo2 = new TXO(fromAddress, 5);
        const outputTXO1 = new TXO(toAddress, 7);
        const outputTXO2 = new TXO(fromAddress, 3);

        const tx = new Transaction([txo1, txo2], [outputTXO1, outputTXO2]);

        tx.execute();

        it('should have zero fee', () => {
            assert.equal(tx.fee, 0);
        });
    });

    describe('with some remainder', () => {
        const txo1 = new TXO(fromAddress, 15);
        const outputTXO1 = new TXO(toAddress, 7);
        const outputTXO2 = new TXO(fromAddress, 6);

        const tx = new Transaction([txo1], [outputTXO1, outputTXO2]);

        tx.execute();

        it('should have the remainder as the fee', () => {
            assert.equal(tx.fee, 2);
        });
    });
});

describe('Transaction', function () {
    const fromAddress = "1DBS97W3jWw6FnAqdduK1NW6kFo3Aid1N6";
    const toAddress = "12ruWjb4naCME5QhjrQSJuS5disgME22fe";

    const txo1 = new TXO(fromAddress, 5);
    const txo2 = new TXO(fromAddress, 5);
    const txo3 = new TXO(fromAddress, 3);
    const txo4 = new TXO(fromAddress, 4);
    const outputTXO1 = new TXO(toAddress, 7);
    const outputTXO2 = new TXO(fromAddress, 3); 

    it('should mark both inputs as spent', () => {
        const tx = new Transaction([txo1, txo2], [outputTXO1, outputTXO2]);
        tx.execute();
        assert(txo1.spent);
        assert(txo2.spent);
    });

    it('should leave both inputs unspent if funds unavailable', () => {
        const tx = new Transaction([txo3, txo4], [outputTXO1, outputTXO2]);
        let ex;
        try {
            tx.execute();
        }
        catch (_ex) {
            ex = _ex;
        }
        assert(ex, "Expected an exception to be thrown!");
        assert(!txo3.spent, "The transaction should be marked as unspent");
        assert(!txo4.spent, "The transaction should be marked as unspent");
    });

    it('should leave valid inputs unspent if a double spend occurs', () => {
        const tx = new Transaction([txo1, txo4], [outputTXO1, outputTXO2]);
        let ex;
        try {
            tx.execute();
        }
        catch (_ex) {
            ex = _ex;
        }
        assert(ex, "Expected an exception to be thrown!");
        assert(!txo4.spent, "The transaction should be marked as unspent");
    });

});

const { assert } = require('chai');
const Transaction = require('../Transaction');
const TXO = require('../TXO');

describe('Transaction', function () {
    const fromAddress = "1DBS97W3jWw6FnAqdduK1NW6kFo3Aid1N6";
    const toAddress = "12ruWjb4naCME5QhjrQSJuS5disgME22fe";
    
    describe('with sufficient UTXOs', () => {
        const txo1 = new TXO(fromAddress, 5);
        const txo2 = new TXO(fromAddress, 5);
        const outputTXO1 = new TXO(toAddress, 10);
        const tx = new Transaction([txo1, txo2], [outputTXO1]);

        it('should execute without error', () => {
            try {
                tx.execute();
            }
            catch (ex) {
                assert.fail(ex.message);
                console.log(ex);
            }
        });
    });

    describe('with insufficient UTXOs', () => {
        const txo1 = new TXO(fromAddress, 3);
        const txo2 = new TXO(fromAddress, 3);
        const txo3 = new TXO(fromAddress, 3);
        const outputTXO1 = new TXO(toAddress, 10);

        const tx = new Transaction([txo1, txo2, txo3], [outputTXO1]);

        it('should throw an error on execute', () => {
            let ex;
            try {
                tx.execute();
            }
            catch (_ex) {
                ex = _ex;
            }
            assert(ex, "Did not throw an exception for a lack of UTXO funds!");
        });
    });
});