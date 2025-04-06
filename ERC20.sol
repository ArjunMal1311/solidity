// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// EIP or Ethereum Improvement Proposal
// ERC20 is a standard for creating fungible tokens on the Ethereum blockchain.
// It defines a set of functions that all ERC20 tokens must implement.

// like name(), symbol(), decimals(), totalSupply(), balanceOf(), transfer(), allowance(), approve(), transferFrom(), etc.



// NFTs are ERC721
// ERC721 is a standard for creating non-fungible tokens on the Ethereum blockchain.
// Non fungible and non interchangeable

// Non fungible means that each token is unique and cannot be replaced by another token.
// Interchangeable means that each token is interchangeable with another token.

// ERC20 is a standard for creating fungible tokens on the Ethereum blockchain.
// Fungible on the other side means that each token is interchangeable with another token.

// NFTs
// mapping (uint256 => address) private _owners (tokenId => owner)



// token URI or token Uniform Resource Identifier
// difference between URL and URI
// URL is a Uniform Resource Locator, URI is a Uniform Resource Identifier
// URL provides location of the resource
// URI provides information about the resource, some point of api call returns the metadata

// IPFS is a decentralized storage system for storing and retrieving data
// not axactly like blockchain

// How it works?
// it firsts hashes the data and then stores the hash in the blockchain
// then we pin that file to a node, node is connected to other nodes
// all talk to each other and find the file when asked to

// different nodes can pin the code, so it is not stored in one place
// there's no smart contract, just a decentralized storage system

// we have different strategies through which other nodes pin the data