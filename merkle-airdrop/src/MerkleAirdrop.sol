// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract MerkleAirdrop is EIP712 {
    // what we are doing
    // some list of addresses
    // allow one who is in the list to claim the token

    using ECDSA for bytes32;
    using SafeERC20 for IERC20;
    // means we can call functions defined in here on a variable of type IERC20

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account,uint256 amount)");


    struct AirdropClaim {
        address account;
        uint256 amount;
    }

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

    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("MerkleAirdrop", "1.0.0") {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }


        if (!_isValidSignature(account, getMessageHash(account, amount), v, r, s)) {
            revert MerkleAirdrop__InvalidSignature();
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


    // message we expect to have been signed
    function getMessageHash(address account, uint256 amount) public view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(MESSAGE_TYPEHASH, AirdropClaim({ account: account, amount: amount }))));
    }


    // verify whether the recovered signer is the expected signer/the account to airdrop tokens for
    function _isValidSignature(address signer, bytes32 digest, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (bool) {
        (address actualSigner, ,) = ECDSA.tryRecover(digest, _v, _r, _s);
        return (actualSigner == signer);
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
