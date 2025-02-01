// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToURI;

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
    }

    function mintNFT(string memory nftTokenURI) public {
        s_tokenIdToURI[s_tokenCounter] = nftTokenURI;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToURI[tokenId];

        
        // token URI or token Uniform Resource Identifier
        // difference between URL and URI
        // URL is a Uniform Resource Locator, URI is a Uniform Resource Identifier
        // URL provides location of the resource
        // URI provides information about the resource, some point of api call returns the metadata
    }

    // each dogie in this collection has a unique tokenId, DOG is collection name

    // so unique NFT is a combination of contract address which represents
    // the collection and tokenId which represents the dogie

    // IPFS is a decentralized storage system for storing and retrieving data
    // not axactly like blockchain

    // How it works?
    // it firsts hashes the data and then stores the hash in the blockchain
    // then we pin that file to a node, node is connected to other nodes
    // all talk to each other and find the file when asked to

    // different nodes can pin the code, so it is not stored in one place
    // there's no smart contract, just a decentralized storage system

    // we have different strategies through which other nodes pin the data
}
