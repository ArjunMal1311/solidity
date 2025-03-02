// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Merkle Trees are a way to keep track of a lot of data in a compact way.
// Merkle tree: a structure used in computer science to validate data
// Merkle root: the hash contained in the block header, which is derived from the hashes of all other transactions in the block
// Merkle path: represents the information which the user needs to calculate the expected value for the Merkle root for a block, 
// from their own transaction hash contained in that block. The Merkle path is used as part of of the Merkle proof
// Merkle proof: proves the existence of a specific transaction in a specific 
// block (without the user needing to examine all the transactions in the block). It includes the Merkle root and the Merkle path


class MerkleTree {
    constructor(leaves, concat) {
        this.leaves = leaves;
        this.concat = concat;
    }
    getRoot(leaves = this.leaves) {
        if (leaves.length === 1) {
            return leaves[0];
        }
        const layer = [];
        for (let i = 0; i < leaves.length; i += 2) {
            const left = leaves[i];
            const right = leaves[i + 1];
            if (right) {
                layer.push(this.concat(left, right));
            }
            else {
                layer.push(left);
            }
        }
        return this.getRoot(layer);
    }
    getProof(index, layer = this.leaves, proof = []) {
        if (layer.length === 1) return proof;
        const newLayer = [];
        for (let i = 0; i < layer.length; i += 2) {
            let left = layer[i];
            let right = layer[i + 1];
            if (!right) {
                newLayer.push(left);
            }
            else {
                newLayer.push(this.concat(left, right));

                if (i === index || i === index - 1) {
                    let isLeft = !(index % 2);
                    proof.push({
                        data: isLeft ? right : left,
                        left: !isLeft
                    });
                }
            }
        }
        return this.getProof(Math.floor(index / 2), newLayer, proof);
    }
}

module.exports = MerkleTree;

// ------------------------------------------------------------------------------------------------

const concat = (a, b) => `Hash(${a} + ${b})`;

describe('merkle', function () {
  it('should handle the base case: [A]', function () {
    const leaves = ['A'];
    const merkleTree = new MerkleTree(leaves, concat);
    assert.equal(merkleTree.getRoot(), "A");
  });

  it('should create a root from two leaves: [A,B]', function () {
    const leaves = ['A', 'B'];
    const merkleTree = new MerkleTree(leaves, concat);
    assert.equal(merkleTree.getRoot(), "Hash(A + B)");
  });

  it('should create a root from four leaves: [A,B,C,D]', function () {
    const leaves = ['A', 'B', 'C', 'D'];
    const merkleTree = new MerkleTree(leaves, concat);
    assert.equal(merkleTree.getRoot(), "Hash(Hash(A + B) + Hash(C + D))");
  });

  it('should create a root from eight leaves: [A,B,C,D,E,F,G,H]', function () {
    const leaves = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    const merkleTree = new MerkleTree(leaves, concat);
    assert.equal(merkleTree.getRoot(), "Hash(Hash(Hash(A + B) + Hash(C + D)) + Hash(Hash(E + F) + Hash(G + H)))");
  });
});

  describe('a given merkle tree', function() {
    const leaves = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];
    const root = "Hash(Hash(Hash(Hash(A + B) + Hash(C + D)) + Hash(Hash(E + F) + Hash(G + H))) + Hash(Hash(I + J) + K))";
    let tree; 
    beforeEach(() => {
      tree = new MerkleTree(leaves.slice(0), concat);
    });

    describe('untampered proofs', function() {
      leaves.forEach((_, i) => {
        it(`should verify the proof for leaf index ${i}`, function() {
          const proof = tree.getProof(i);
          assert.equal(verify(proof, leaves[i], root, concat), true);
        });
      });
    });

    describe('tampered proofs', function() {
      describe('verifying a different node with a proof', function() {
        it('should not verify the proof', function() {
          let proof = tree.getProof(2);
          assert.equal(verify(proof, leaves[3], root, concat), false);
        });
      });

      describe('verifying a different root', function() {
        it('should not verify the proof', function() {
          let proof = tree.getProof(2);
          const badRoot = "Hash(Hash(Hash(Hash(A + C) + Hash(C + D)) + Hash(Hash(E + F) + Hash(G + H))) + Hash(Hash(I + J) + K))";
          assert.equal(verify(proof, leaves[2], badRoot, concat), false);
        });
      });

      describe('flipping a nodes position', function() {
        it('should not verify the proof', function() {
          let proof = tree.getProof(3);
          proof[1].left = !proof[1].left;
          assert.equal(verify(proof, leaves[3], root, concat), false);
        });
      });

      describe('editing a hash', function() {
        it('should not verify the proof', function() {
          let proof = tree.getProof(5);
          proof[2].data = "Q";
          assert.equal(verify(proof, leaves[5], root, concat), false);
        });
      });
    });
  });