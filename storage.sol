// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// **Storage** is the specific area within the blockchain where data associated with a smart contract is permanently saved. These are the variables that we defined at the top of our contract, before going into functions, also called **state variables** or **global variables**.


// The important aspects are the following:

// * Each storage has 32 bytes;
// * The slots numbering starts from 0;
// * Data is stored contiguously starting with the first variable placed in the first slot;
// * Dynamically-sized arrays and mappings are treated differently (we'll discuss them below);
// * The size of each variable, in bytes, is given by its type;
// * If possible, multiple variables < 32 bytes are packed together;
// * If not possible, a new slot will be started;
// * Immutable and Constant variables are baked right into the bytecode of the contract, thus they don't use storage slots.



// uint256 var1 = 1337;
// uint256 var2 = 9000;
// uint64 var3 = 0;

// In `slot 0` we have `var1`, in `slot 1` we have `var2`, and in `slot 2` we have `var 3`. Because `var 3` only used 8 bytes, we have 24 bytes left in that slot. Let's try another one:



// uint64 var1 = 1337;
// uint128 var2 = 9000;
// bool var3 = true;
// bool var4 = false;
// uint64 var5 = 10000;
// address user1 = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
// uint128 var6 = 9999;
// uint8 var7 = 3;

// uint128 var8 = 20000000;


// Let's structure them better this time:

// `slot 0`

// * var1 8 bytes (8 total)
// * var2 16 bytes (24 total)
// * var3 1 byte (25 total)
// * var4 1 byte (26 total)
// * var5 has 8 bytes, it would generate a total of 34 bytes, but we have only 32 so we start the next slot

// `slot 1`

// * var5 8 bytes (8 total)
// * user1 20 bytes (28 total)
// * var6 has 16 bytes, it would generate a total of 44 bytes, we have a max of 32 so we start the next slot

// `slot2`

// * var6 16 byes (16 total)
// * var7 1 byte (17 total)
// * var8 has 16 bytes, it would generate a total of 33 bytes, but as always we have only 32, we start the next slot

// `slot3`

// * var8 16 bytes (16 total)


// Can you spot the inefficiency? `slot 0` has 6 empty bytes, `slot 1` has 4 empty bytes, `slot 2` has 15 empty bytes, `slot 3` has 16 empty bytes. Can you come up with a way to minimize the number of slots?
// What would happen if we move `var7` between `var4` and `var5`, so we fit its 1 byte into `slot 0`, thus reducing the total of `slot2` to 16 bytes, leaving enough room for `var8` to fit in. You get the gist.
// The total bytes of storage is 87. We divide that by 32 and we find out that we need at least 2.71 slots ... which means 3 slots. We cannot reduce the number of slots any further.



// Optimizing Gas Costs
// function withdraw() public onlyOwner {
//     uint256 fundersLength = s_funders.length;

//     // Made it efficient by calling the length from funders array from the storage only once
//     // rather than using s_funders.length in the for loop
//     // Remember calling the length of the array from storage is expensive
//     // so we should avoid it as much as possible
//     for (
//         uint256 funderIndex = 0;
//         funderIndex < fundersLength;
//         funderIndex++
//     ) {
//         address funder = s_funders[funderIndex];
//         s_addressToAmountFunded[funder] = 0;
//     }
//     delete s_funders;
//     s_funders = new address[](0);

//     uint256 amount = address(this).balance;
//     (bool callSuccess, ) = payable(msg.sender).call{value: amount}("");
//     if (!callSuccess) {
//         revert FundMe__FailWithdraw();
//     }

//     emit Withdraw(amount);
// }