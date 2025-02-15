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
    address gasPayer;
    address user;
    uint256 userPrivKey;

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
        gasPayer = makeAddr("gasPayer");
        (user, userPrivKey) = makeAddrAndKey("user");
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




    // Transaction Types
    // 0x0 Legacy
    // 0x1 contains array of access list and storage keys
    // 0x2 added maxPriorityFeePerGas and baseFees

    // 0x3 Scaling solution for rollups, added max_blob_gas and blob_versioned_hashes
    // 0x71 standardize the message data structure
    // smart contracts must be deployed using this type 0x71 or 113
    // additional fields -> gasPerPubData, customSignature, payMasterParams, factory_deps

    // 0xff - priortity transactions



    // in a normal transaction, all transaction are stored on the chain
    // Rollsups help to scale ethereum so that transactions are not expensive

    // Bundle up transactions and then send it to the chain
    // compressed transactions send to chain and ethereum has to do little work
    // to verify batch of transactions

    // here's was the issue earlier we used to store complete transactions on the
    // ethereum node

    // blobs are new transaction type that allows us to store data on chain for short period of time
    // we cant access the data itself, but we can access the hash of the data
    // blobs were added because rollups wanted a cheaper way to validate transactions

    // How do rollups work?
    // 1. submit a transaction with a blob along with some proof data
    // 2. contract on chain access a hash of the blob with BLOBHASH opcode
    // 3. it will then pass BLOBHASH combined with proof data to new point
    // evaluation opcode to help verify the transaction batch

    function signMessage(uint256 privKey, address account) public view returns (uint8 v, bytes32 r, bytes32 s) {
        bytes32 hashedMessage = airdrop.getMessageHash(account, AMOUNT_TO_CLAIM);
        (v, r, s) = vm.sign(privKey, hashedMessage);
    }


    function testUsersCanClaim() public {
        uint256 startingBalance = token.balanceOf(user);

        // get the signature
        vm.startPrank(user);
        (uint8 v, bytes32 r, bytes32 s) = signMessage(userPrivKey, user);
        vm.stopPrank();

        // gasPayer claims the airdrop for the user
        vm.prank(gasPayer);
        airdrop.claim(user, AMOUNT_TO_CLAIM, PROOFS, v, r, s);
        uint256 endingBalance = token.balanceOf(user);
        console.log("Ending balance: %d", endingBalance);
        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);
    }
}
