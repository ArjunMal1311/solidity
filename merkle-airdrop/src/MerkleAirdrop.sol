// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    // what we are doing
    // some list of addresses
    // allow one who is in the list to claim the token

    using SafeERC20 for IERC20;
    // means we can call functions defined in here on a variable of type IERC20

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    event Claim(address indexed account, uint256 amount);

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address claimer => bool claimed) private s_hasClaimed;

    // when we claim we have to loop through the list
    // which is very gas inefficient and expensive

    // so we will use merkle proofs to verify if a user is in the list
    // and then we will allow them to claim the token

    // merkle proofs are a way to verify if a user is in the list
    // without revealing the entire list
    
    // at base of tree we have leaf nodes
    // there's hash of data on leaf nodes

    // nodes are hashed at each level then combined to form a merkle tree
    // we get unique hash at the root of the tree

    // if we get the same hash then the address is there in the list

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        // verify if the user is in the list

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        // we encoded the numbers together to get a unique hash
        // we hash it twice in order to avoid collision
        // (second pre-image attack)

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }

        s_hasClaimed[account] = true;
        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    function getMerkleRoot() public view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() public view returns (IERC20) {
        return i_airdropToken;
    }
}

// What is airdrop?
// where token development team send token to the users without any cost
// why airdrop?
// to promote their token
// how to do airdrop?
// 1. create a smart contract
// 2. create a function to send token to the users


// We are going to use merkle proffs which is a way to verify if a user 
// is in the list of users who will receive the token
