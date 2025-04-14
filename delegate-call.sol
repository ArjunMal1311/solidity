// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// There are different ways one executes another contract's function
// Normal call
// contractB.call();
// Contract A asks Contract B to run a function
// Function runs in Contract B's storage

// Delegate Call
// contractB.delegatecall();
// Contract A borrows Contract B's function
// Function runs in Contract A's storage

// Think of it like this:
// In a normal call, you tell your friend to write something in their notebook.
// In a delegate call, you borrow their pen and write it in your notebook.


// Why Does Delegate Call Exist --> UpgradableSmart Contracts 


// Contract B (Logic)
contract B {
    uint public num;  // Storage variable in Contract B

    function setNum(uint _num) public {
        num = _num;
    }
}

// Contract A (Proxy)
contract A {
    uint public num;  // Storage variable in Contract A

    function setVars(address _contractB, uint _num) public {
        (bool success, ) = _contractB.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );
        require(success, "Delegate call failed");
    }
}

// ✅ Normal Call: If Contract A did contractB.call(...), it would change num in Contract B’s storage.
// ✅ Delegate Call: Since we used delegatecall, it changes num in Contract A’s storage instead!



// Why is Delegate Call Risky?
// Since it blindly assigns values based on storage slots, mistakes happen:

// If Contract A and B have different storage layouts, data can get overwritten incorrectly.
// If A expects a uint, but B assigns a bool, weird things happen.


// 🚨 Example Bug:
// Contract A has bool isActive at storage slot 0.
// Contract B has uint num at storage slot 0.
// Delegate call writes 22 into slot 0.
// In Solidity, any number other than 0 means true, so isActive becomes true even if it wasn’t intended!

// A safer approach: Use OpenZeppelin’s upgradeable contracts instead of writing raw delegatecall.