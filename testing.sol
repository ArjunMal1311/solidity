// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// Testing in Solidity is crucial to ensure your smart contracts work correctly and securely.

// 1. Unit Testing (Test a single function in isolation)
// function add(uint a, uint b) public pure returns (uint) {
//     return a + b;
// }


// 2. Integration Testing (Multiple components interacting)
// Example:Deploy an ERC20 token and a staking contract.
// Transfer tokens, approve, and stake.

// function testStakeFlow() public {
//     token.mint(address(this), 1000);
//     token.approve(address(staking), 1000);
//     staking.stake(1000);
    
//     assertEq(staking.balanceOf(address(this)), 1000);
// }


// 3. Fuzz Testing (Automatic testing with random inputs)
// Goal: Catch unexpected edge cases by feeding random inputs.

// function testAddFuzz(uint a, uint b) public {
//     uint result = contract.add(a, b);
//     assert(result >= a); // Simple invariant
// }

contract MyContract {
    uint256 public shouldAlwaysBeZero = 0;
    uint256 hiddenValue = 0;

    function doStuff(uint256 data) public {
        if (data == 2){
            shouldAlwaysBeZero = 1;
        }
    }
}

// In the above `shouldAlwaysBeZero` == 0 is our `invariant`, the property of our system that should always hold. By fuzz testing this code, our 
// test supplies our function with random data until it finds a way to break the function, in this case if 2 was passed as an argument our invariant would break.


// Below is unit test
// function testIAlwaysGetZero() public {
//     uint256 data = 0;
//     myContract.doStuff(data);
//     assert(myContract.shouldAlwaysBeZero() == 0);
// }


// Below is fuzz test ->  it'll throw random data at our function as many times as we tell it to (we'll discuss runs soon), until it breaks our assertion.
// function testIAlwaysGetZero(uint256 data) public {
//     myContract.doStuff(data);
//     assert(myContract.shouldAlwaysBeZero() == 0);
// }



// Stateful Fuzz Testing
// Stateless fuzzing means:
// Your function is tested with random inputs, and the function does not depend on prior contract state.

// best for
// Pure/view functions
// Functions with predictable behavior
// Input validation

contract Calculator {
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
}

// contract CalculatorTest {
//     Calculator public calc;

//     function setUp() public {
//         calc = new Calculator();
//     }

//     function testAddFuzz(uint a, uint b) public {
//         uint result = calc.add(a, b);
//         assertGe(result, a); // Invariant: result >= a
//         assertGe(result, b); // Invariant: result >= b
//     }
// }


// Stateful fuzzing = testing invariants and behavior over a sequence of interactions, not just random inputs to a single function.
// Key ideas:
// You track state over time

// You define invariants that should always hold, no matter the input
// You fuzz not just inputs, but actions

contract Bank {
    mapping(address => uint) public balances;
    uint public totalBalance;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount;
        totalBalance -= amount;
        payable(msg.sender).transfer(amount);
    }
}

// contract BankInvariantTest is StdInvariant, Test {
//     Bank bank;

//     address alice = address(0xA11CE);
//     address bob = address(0xB0B);

//     function setUp() public {
//         bank = new Bank();
//         vm.deal(alice, 100 ether);
//         vm.deal(bob, 100 ether);
//     }

//     function invariantTotalBalanceIsCorrect() public {
//         // The actual ETH in the contract must match totalBalance
//         assertEq(address(bank).balance, bank.totalBalance());
//     }

//     function invariantNoNegativeBalances() public {
//         assertGe(bank.balances(alice), 0);
//         assertGe(bank.balances(bob), 0);
//     }

//     // Example fuzzed action
//     function depositRandom(uint amount) public {
//         address user = randomUser();
//         amount = bound(amount, 0, 10 ether);
//         vm.prank(user);
//         bank.deposit{value: amount}();
//     }

//     function withdrawRandom(uint amount) public {
//         address user = randomUser();
//         amount = bound(amount, 0, bank.balances(user));
//         vm.prank(user);
//         bank.withdraw(amount);
//     }

//     function randomUser() internal view returns (address) {
//         return block.timestamp % 2 == 0 ? alice : bob;
//     }

//     receive() external payable {}
// }

// the difference between stateless and stateful fuzz testing is like comparing poking a function vs running a full simulation


// ANALOGY
// Stateless fuzzing: "Try every button and check what it returns"
// Stateful fuzzing: "Play the entire game in random ways and make sure the score is never negative"