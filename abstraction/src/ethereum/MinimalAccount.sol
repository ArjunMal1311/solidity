// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IAccount} from "lib/account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "lib/account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";


contract MinimalAccount is IAccount, Ownable {

    // Errors
    error MinimalAccount__NotFromEntryPoint();
    error MinimalAccount__NotFromEntryPointOrOwner();
    error MinimalAccount__CallFailed(bytes);
    
    // State Variables
    IEntryPoint private immutable i_entryPoint;

    
    // Modifiers
    modifier requireFromEntryPoint() {
        if (msg.sender != address(i_entryPoint)) {
            revert MinimalAccount__NotFromEntryPoint();
        }
        _;
    }

    modifier requireFromEntryPointOrOwner() {
        if (msg.sender != address(i_entryPoint) && msg.sender != owner()) {
            revert MinimalAccount__NotFromEntryPointOrOwner();
        }
        _;
    }


    // Constructor
    constructor(address entryPoint) Ownable(msg.sender) {
        i_entryPoint = IEntryPoint(entryPoint);
    }

    receive() external payable {}


    // Functions (external)
    function execute(address dest, uint256 value, bytes calldata functionData) external requireFromEntryPointOrOwner {
        (bool success, bytes memory result) = dest.call{value: value}(functionData);
        if (!success) {
            revert MinimalAccount__CallFailed(result);
        }
    }

    function validateUserOp(PackedUserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds) external requireFromEntryPoint returns (uint256 validationData) {
        // userOp --> user Operation to validate
        // userOpHash --> hash of the user operation
        // missingAccountFunds --> amount of ETH required to pay for the user operation

        // returns validation data 


        validationData =_validateSignature(userOp, userOpHash);
        // if everything is ok then we pay to the entrypoint and revert if not
        _payPrefund(missingAccountFunds);

    }

    

    // Internal Functions
    function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash) internal view  returns (uint256 validationData){
        // validate the signature of the user operation
        // return the validation data


        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
        address signer = ECDSA.recover(ethSignedMessageHash, userOp.signature);

        if (signer != owner()) return SIG_VALIDATION_FAILED;

        return SIG_VALIDATION_SUCCESS;
    }

    // For the above function
    // struct PackedUserOperation {
    //     address sender;
    //     uint256 nonce;
    //     bytes initCode;
    //     bytes callData;
    //     bytes32 accountGasLimits;
    //     uint256 preVerificationGas;
    //     bytes32 gasFees;
    //     bytes paymasterAndData;
    //     bytes signature;
    // }

    // from userOpHash we get the address of the signer and we compare it with the owner
    // if it is the owner, we return SIG_VALIDATION_SUCCESS
    // if it is not the owner, we return SIG_VALIDATION_FAILED



    function _payPrefund(uint256 missingAccountFunds) internal {
        // pay the prefund
        // missingAccountFunds --> amount of ETH required to pay for the user operation

        if (missingAccountFunds != 0) {
            (bool success, ) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
            (success);
        }
    }


    // Getters
    function getEntryPoint() external view returns (address) {
        return address(i_entryPoint);
    }
}
