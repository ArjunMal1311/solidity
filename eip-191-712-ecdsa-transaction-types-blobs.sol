// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EIP {
    // EIP 191
    // Goal: Let someone sign a message off-chain and you verify that signature on-chain to act on their behalf (e.g., claim tokens for them).

    function getMessageHashEIP191(bytes32 message) public view returns (bytes32) {
        return keccak256(abi.encodePacked(bytes1(0x19), bytes1(0x00), validator, message));
    }

    // 0x19 is a prefix as per EIP-191.
    // 0x00 refers to the version of the standard.
    // validator is the address that is intended to verify the signature (in this case, the contract).
    // message is what you're signing — could be "ClaimToken", for instance.

    // All of that is hashed with keccak256 (Ethereum's default hashing algo).
    // Then you use:
    hash.toEthSignedMessageHash().recover(signature)


    // This adds the "\x19Ethereum Signed Message:\n" prefix (which wallets like MetaMask auto-add).
    // Then recover() gets the public key (address) from the signature.
    // You compare that to the sender.



    // ✍️ EIP-712
    // Goal: Typed structured data signing. Safer and clearer than EIP-191. Wallets show human-readable messages like:
    // “Do you want to claim 100 tokens on contract X?”


    bytes32 private constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 private constant CLAIM_TYPEHASH = keccak256("Claim(address user,uint256 amount)");

    // These define how to build the message. You define:
    // Domain type (app name, version, chain ID, and contract address).
    // Claim type (user and amount).


    DOMAIN_SEPARATOR = keccak256(
        abi.encode(
            DOMAIN_TYPEHASH,
            keccak256("SignatureAndRollupDemo"), // app name
            keccak256("1"), // version
            block.chainid,
            address(this)
        )
    );

    // This is the domain separator, which binds the signature to:
    // A specific app
    // A specific contract
    // A specific chain


    function hashClaim(address user, uint256 amount) internal view returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                \"\\x19\\x01\",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(CLAIM_TYPEHASH, user, amount))
            )
        );
    }

    // 0x19 0x01 is fixed per EIP-712
    // DOMAIN_SEPARATOR: binds this message to our contract and domain
    // keccak256(abi.encode(...)): encodes the structured message (Claim(user, amount))



    // 🔢 ECDSA (Elliptic Curve Digital Signature Algorithm)
    // You generate a signature off-chain:
    // sign(hash) returns (v, r, s).
    // r is the x-coordinate on the curve (secp256k1).
    // s proves you know the private key.
    // v determines polarity of the y-axis (for curve symmetry).

    // On-chain:
    // You use ecrecover() or OpenZeppelin’s .recover() to get the address back from (r, s, v) and the hashed message.

    // Bonus Math:
    // R = k * G → point on the curve
    // r = R.x % n
    // s = (h + r * privKey) / k mod n

    // Verification reverses that to check: r == (k * G).x % n


    // ⚙️ Ethereum Transaction Types
    // 0x0	Legacy	Basic tx, no gas optimization
    // 0x1	AccessList	Introduced access lists (gas optimization)
    // 0x2	EIP-1559	Introduced maxFeePerGas, priorityFeePerGas
    // 0x3	EIP-4844 (Blob)	For rollups, includes blob_hashes
    // 0x71	zkSync / EIP-7212	Adds paymasterParams, customSignature, etc.
    // 0xff	PriorityTx	Used for high-priority system transactions


    // 🧱 Rollups + Blobs
    function submitRollup(bytes32 blobHash, bytes32 proofHash) external {
        emit RollupSubmitted(blobHash, proofHash);
    }

    // This simulates:
    // 1. Rollup operator compresses transactions off-chain.
    // 2. Uploads blob with compressed data (not permanently stored on-chain).
    // 3. Uploads proofHash — cryptographic proof that data is valid.
    // 4. On-chain contract uses BLOBHASH (new opcode) to verify data.
    // 5. ⛔ You can't access the blob data from the contract — only the hash. So it's cheaper.
}
