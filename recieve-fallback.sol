// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// In Solidity, if Ether is sent to a contract without a `receive` or `fallback` function, the transaction will be **rejected**, and the Ether will not be transferred.

contract FallbackExample {
    uint256 public result;

    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}

// Ether is sent to contract
//      is msg.data empty?
//          /   \
//         yes  no
//         /     \
//    receive()?  fallback()
//     /   \
//   yes   no
//  /        \
//receive()  fallback()


// The receive function is specifically designed to handle Ether transfers without data and is automatically invoked when Ether. 
// The fallback function is used for handling calls with data or when the receive function is not defined. The fallback function can also handle Ether transfers with data.