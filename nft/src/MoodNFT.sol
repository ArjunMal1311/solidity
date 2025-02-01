// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract MoodNFT is ERC721 {
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error MoodNft__CantFlipMoodIfNotOwner();
    error MoodNft__MoodAlreadyFlipped();

    enum NFTState {
        HAPPY,
        SAD
    }

    mapping(uint256 => NFTState) private s_tokenIdToState;

    uint256 private s_tokenCounter;
    string private s_sadSVGURI;
    string private s_happySVGURI;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(string memory sadSVGURI, string memory happySVGURI) ERC721("MoodNFT", "MN") {
        s_tokenCounter = 0;
        s_sadSVGURI = sadSVGURI;
        s_happySVGURI = happySVGURI;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;

        s_tokenCounter = s_tokenCounter + 1;
        emit CreatedNFT(s_tokenCounter);
    }

    function flipMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            s_tokenIdToState[tokenId] = NFTState.SAD;
        } else {
            s_tokenIdToState[tokenId] = NFTState.HAPPY;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // Just like we can encode our svg to base64 we can encode our json to base64
        // and store that in the contract

        // we are going to use zeppelin to convert json object into json token URI
        if (ownerOf(tokenId) == address(0)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        string memory imageURI = s_happySVGURI;

        if (s_tokenIdToState[tokenId] == NFTState.SAD) {
            imageURI = s_sadSVGURI;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )

            // first we created string, concatenate it with abi.encodePacked, turned it into bytes object, encoded it to base64
            // and then we returned it
        );
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySVGURI;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSVGURI;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

}