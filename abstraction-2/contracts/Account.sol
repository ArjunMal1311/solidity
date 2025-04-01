// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@account-abstraction/contracts/core/EntryPoint.sol";
import "@account-abstraction/contracts/interfaces/IAccount.sol";

contract Account is IAccount {
    address public owner;
    uint256 public count;

    constructor(address _owner) {
        owner = _owner;
    }

    function validateUserOp(UserOperation calldata, bytes32, uint256) external pure returns (uint256 validationData) {
        return 0;
    }

    // this is our state changing function, which could be called anything
    function execute() external {
        count++;
    }
}

contract AccountFactory {
    function createAccount(address _owner) external returns (address) {
        return address(new Account(_owner));
    }
}



// How the EntryPoint interacts with AccountFactory
// theres a method _createSenderIfNeeded
// runs for every userop

// it checks the initCode if its not zero then it initializes
// a smart account

// sender that you passed into the user op is the same as sender
// that it gets back from the senderCreator.createSender method

// senderCreator is taking an initCode which is one of the fields in the UserOp
// first 20 bytes will be the address of the factory
// rest of the init code is whatever we are sending to account factory

