// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


// The Bytecode object represents the binary that is actually being put on the blockchain, when we send a transaction.

// This is what is meant by being `EVM Compatible`, `Polygon`, `Avalanche`, `Arbitrum` etc all compile to the same style of binary, readable by the `Ethereum Virtual Machine`

// Now, why are we talking about all this? How does it relate to abi encoding?
// Until now we've only seen abi.encodePacked used to concatenate strings, but it's capable of much more.

contract Encode {
    function encodeNumber() public pure returns(bytes memory){
        bytes memory number = abi.encode(1);
        return number;
    }

    function encodeString() public pure returns(string memory){
        bytes memory someString = abi.encode("some string");
        return string(someString);
    }

    function encodeStringPacked() public pure returns(bytes memory){
        bytes memory someString = abi.encodePacked("some string");
        return someString;
    }

    function encodeStringBytes() public pure returns(bytes memory) {
        bytes memory someString = bytes("some string");
        return someString;
    }

    function multiEncode() public pure returns(bytes memory){
        bytes memory someString = abi.encode("some string", "it's bigger!");
        return someString;
    }

    function multiDecode() public pure returns(string memory, string memory){
        (string memory someString, string memory someOtherString) = abi.decode(multiEncode(),(string,string));
        return (someString, someOtherString);
    }

    function multiEncodePacked() public pure returns (bytes memory){
        bytes memory someString = abi.encodePacked("some string", "it's bigger!");
        return someString;
    }
}

// encodePacked is used to encode multiple values into a single bytes object.
// It's different from encode in that it doesn't pad the values to the same length.
// This means that the values are packed together without any padding, which can save gas.
// However, it's important to note that encodePacked can be less readable and more prone to errors.


// 'call' allows the function to modify the contract's state while 'staticcall' only reads data without changing the contract's state.
// The EVM interprets the compiled bytecode generated from Solidity code, executing the instructions to manage the contract's state and logic.