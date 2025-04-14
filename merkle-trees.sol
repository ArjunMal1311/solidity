// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Merkle Trees

// Merkle Trees are a way to verify that a given element is part of a set without revealing the entire set.
// They are a type of hash tree, which is a tree data structure in which each non-leaf node is the hash of its children.


// The top of the tree is the **root hash**, created by hashing together pairs of adjacent nodes. This process continues up the tree, resulting in a single **root hash** that will represents all the data in the tree.

// Merkle proofs will verify that a specific piece of data is part of a Merkle Tree and consist of the hashes of **sibling nodes** present at each level of the tree.
// For example, to prove that `Hash B` is part of the Merkle Tree, you would provide _Hash A_ (sibling 1) at the first level, and the _combined 
// hash of Hash C and Hash D_ (sibling 2) at the second level as proofs.

// The **root** is typically stored _on-chain_, while the **proof** is generated off-chain


// The processProof function iterates through the proof array, updating the computed hash by hashing it with the next proof element. 
// This process ultimately returns a computed hash, which is compared to the expected root to verify the leaf's presence in the Merkle Tree.

// function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
//     bytes32 computedHash = leaf;
//     for (uint256 i = 0; i < proof.length; i++) {
//         computedHash = _hashPair(computedHash, proof[i]);
//     }
//     return computedHash;
// }




// Sample
{
  "types": ["address", "uint"],
  "count": 4,
  "values": {
    "0": {
      "0": "0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D",
      "1": "2500000000000000000"
    },
    "1": {
      "0": "0xf39Fd6e51aad88F6F4c6aB8827279cffFb92266",
      "1": "2500000000000000000"
    },
    "2": {
      "0": "0c8Ca207e27a1a8224D1b602bf856479b03319e7",
      "1": "2500000000000000000"
    },
    "3": {
      "0": "0xf6dBa02C01AF48Cf926579F77C9f874Ca640D91D",
      "1": "2500000000000000000"
    }
  }
}

// you'd compute:

// L0 = hash(addr0 + amount0)

// L1 = hash(addr1 + amount1)

// L2 = hash(addr2 + amount2)

// L3 = hash(addr3 + amount3)

// 2. Then, Pairing for Parent Nodes:
// P0 = hash(L0 + L1)

// P1 = hash(L2 + L3)

// 3. Finally:
// Root = hash(P0 + P1)

//          Root
//         /    \
//       P0      P1
//      /  \    /  \
//    L0  L1  L2  L3




function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
    bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
    if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
        revert MerkleAirdrop__InvalidProof();
    }
}


// bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
// we encoded the numbers together to get a unique hash
// we hash it twice in order to avoid collision
// (second pre-image attack)