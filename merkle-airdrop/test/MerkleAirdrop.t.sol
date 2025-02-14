// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {BagelToken} from "../src/BagelToken.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployMerkleAirdrop} from "../script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is Test, ZkSyncChainChecker {
    MerkleAirdrop public airdrop;
    BagelToken public token;

    bytes32 public ROOT =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = AMOUNT_TO_CLAIM * 4;

    bytes32[] public PROOFS = [
        bytes32(
            0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a
        ),
        bytes32(
            0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576
        )
    ];

    address public constant VALID_USER = 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D;

    function setUp() public {
        if (!isZkSyncChain()) {
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (airdrop, token) = deployer.deployMerkleAirdrop();
        } else {
            token = new BagelToken();
            airdrop = new MerkleAirdrop(ROOT, token);

            token.mint(token.owner(), AMOUNT_TO_SEND);
            token.transfer(address(airdrop), AMOUNT_TO_SEND);
        }
    }

    // hey user, you are in the list
    // i give you the permission to go claim the token for me
    // and pay for my transaction fees and I will recieve the airdrop
    // i dont want to claim myself
    // we can do this using signatures
    // (sign it via my private key)

    // EIP 191 signature
    // prefix to 0x19
    // eip191Version -> bytes1(0)
    // indendedValidatorAddress = address(this)
    // applicationSpecificData = bytes32(message)

    // abi encode the above data, hash the message, then sign the message and send it
    

    // EIP 721
    // 0x19 0x01 <domain separator> <hashStruct(message)>
    // domain separator is the hash of name, version, chainId, verifyingContract

    // hashStruct(message) is the hash of - (down below)
    // what is type of the message and the other is what is the message itself
    

    // 0x19 0x01 <hash of who verifies this signaure and what the verifier looks like> hash of signed structures message, and what the signature looks like>


    // ECDSA
    // Elliptic Curve Digital Signature Algorithm

    // private key is used to sign the message and public key is used to verify the message
    // private key is a random number, public key is derived from the private key
    // elliptical curve is symmetric to X axis

    // (v, r, s) -> are the points on the elliptical curve
    // If a malicious actor has access to one of those signatures even without private key, they can forge the signature
    // g is random point on the curve
    // n is prime number generated using g and defines the length of the private key

    // signatures (v, r, s) r : x point on the secp256k1 curve
    // s: proof signer knows the private key
    // v: +ve or -ve part of the curve (POLARITY)
    
    // R = k. G
    // k is random number
    // R = (x, y)
    // r = x mod n

    // s1 = s^(-1) mod n
    // r' = (h * s1) * G
    // r' = (x, y)
    // r' = x mod n

    // r' == r ?


    function testUsersCanClaim() public {
        uint256 startingBalance = token.balanceOf(VALID_USER);

        vm.prank(VALID_USER);
        airdrop.claim(VALID_USER, AMOUNT_TO_CLAIM, PROOFS);

        uint256 endingBalance = token.balanceOf(VALID_USER);

        console.log("endingBalance", endingBalance);
        console.log("startingBalance", startingBalance);

        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);
    }
}
