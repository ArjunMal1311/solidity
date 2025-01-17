// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {console} from "forge-std/console.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    HelperConfig helperConfig;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    // Storage variables 
    // When we talk about global variables they are stuck in something called storage
    // its like a big giant list of all variables that we create
    // it gets stored in the blockchain
    // [0] is the first variable
    // [1] is the second variable
    // [2] is the third variable
    // [3] is the fourth variable
    // .....

    // 0x00.....19 [uint256]
    // 0x00.....01 [boolean]

    // in case there is dynmaic array or mapping there are dynamic values
    // these are stored in the storage with the help of hashing function

    // at [2] we have the array length 0x00....01
    // at [3] we have the [keccack256(2)] 0x00..0de which is the element of the array

    // constant and immutable do not take spots in storage
    // they are part of contract's bytecode

    // variables inside functions are not stored in storage
    // they are added to their own data structure like stack or memory
    // and are deleted after the function call is finished

    // we can get to know more about through the below command
    // forge inspect FundMe storageLayout

    // Reading and writing to storage is expensive
    // so we should avoid it as much as possible

    // we can read and write from memory
    // memory is a temporary storage
    // it is deleted after the function call is finished

    // Add receive function to accept ETH
    receive() external payable {}

    function setUp() external {
        helperConfig = new HelperConfig();
        address priceFeed = helperConfig.activeNetworkConfig();
        fundMe = new FundMe(priceFeed);
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // function testOwnerIsMsgSender() public {
    //     assertEq(fundMe.i_owner(), address(this));
    // }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    // forge test -vvvv

    //   [10220] FundMeTest::testPriceFeedVersionIsAccurate()
    //     ├─ [5117] FundMe::getVersion() [staticcall]
    //     │   ├─ [0] 0xf29DBB107D7b2b75B4d943CBFfA3272dD471cB14::version() [staticcall]
    //     │   │   └─ ← [Stop]
    //     │   └─ ← [Revert] EvmError: Revert
    //     └─ ← [Revert] EvmError: Revert

    // This will give us an error because we don't have the price feed in the constructor
    // we are calling the contract address which doesnt exist
    // when we dont mention the chain foundry will automatically spin up anvil chain and delete that
    // so we are making contact to a chain that doesnt exist

    // forge test -m testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL
    // what will happen is Anvil get spun up but it will take copy of Sepolia rpc url
    // and make transactions if working like on a real chain

    function testFundFailsWithoutEnoughtEth() public {
        vm.expectRevert();
        // the next line should revert!
        fundMe.fund(); // sends 0 USD which fails
    }

    function testFundUpdatesFundedDataStructure() public {
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(this));
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunders(0);
        assertEq(funder, USER);
    }

    // function testOnlyOwnerCanWithdraw() public {
    //     vm.prank(USER);
    //     fundMe.fund{value: SEND_VALUE}();

    //     vm.expectRevert();
    //     vm.prank(USER);
    //     fundMe.withdraw();
    // }

    // Things can go big like using the
    // vm.prank(USER);
    // fundMe.fund{value: SEND_VALUE}();

    // using these again and again

    // we can use modifier

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    // we can test a code in a pattern
    // arrange, act, assert
    // arrange is setting up the test
    // act is doing the action
    // assert is checking the result

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();


        // Act with actual gas considerdation since anvil chain gas price is 0
        // uint gasStart = gasleft();
        // vm.prank(fundMe.getOwner());
        // fundMe.withdraw();
        // uint gasEnd = gasleft();
        // console.log("Gas used:", (gasStart - gasEnd) * tx.gasprice);

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);

        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawWithMultipleFunders() public {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // hoax does both prank and deal combined
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act 
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance
        );
    }
}

// Testing is very important
// forge test
// it runs the test in the test file by running all the functions
