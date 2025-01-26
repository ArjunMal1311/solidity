// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Raffle
 * @author Arjun Malhotra
 * @notice This contract is a simple raffle contract
 */

contract Raffle {
    // Errors
    error SendMoreToEnterRaffle();
    error RaffleNotOpen();

    // Events
    event RaffleEntered(address indexed player);
    
    // We wont be able to change the entrance fee once the contract is deployed
    uint256 public immutable i_entranceFee;
    address[] private s_players; // not constant or immutable since players can be added and removed
    uint256 public immutable i_interval; // duration of the raffle in seconds
    uint256 public s_lastTimeStamp;
    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        // msg.value is the amount of ETH sent to the contract
        // require is a function that checks if the condition is true
        // if the condition is not true, the function will revert and the transaction will be cancelled
        // if the condition is true, the function will continue
        // require(msg.value >= i_entranceFee, "Not enough ETH");

        // In latest solidity, we have called revert() instead of require()
        // like 
        if (msg.value < i_entranceFee) {
            revert SendMoreToEnterRaffle(); // error SendMoreToEnterRaffle defined above
        }


        // Reason they introduced as revert() is that require() is not gas efficient

        // update solidity 0.8.26^
        // we can directly use custom error inside the require()

        // require(msg.value >= i_entranceFee, SendMoreETH()); 
        // This technically is taking a lot of time to compile and also more gas so the above one is most gas efficient



        // msg.sender is the address of the player who is entering the raffle
        s_players.push(payable(msg.sender));

        // Rule of thumb
        // Logging and Events 
        // EVM has a function called logging
        // EVM writes specific data to the blockchain called logs
        // Inside the logs is an important data called event
        // Events are used to print information to logging structure
        // in a way of more gas efficient way

        // event storedNumber(
        //     uint256 indexed oldNumber,
        //     uint256 indexed newNumber,
        //     uint256 value
        // );

        // there are 2 types of events
        // 1. indexed
        // 2. non-indexed

        // indexed is used to filter the event, faster to search also known as topics
        // non-indexed is used to store the event


        // how does the event look like?
        // we have address of the contract, and account the event is emitted from
        // indexed data, data

        // non indexed data is the data that is not indexed, takes less gas and slower to search

        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external {
        // 1. Pick a random winner
        // 2. Use Random Number to pick a winner
        // 3. Be automatically called after a certain amount of time

        // block.timestamp is the current timestamp of the block
        // block.timestamp - s_lastTimeStamp is the difference in seconds between the current timestamp and the last timestamp
        // i_interval is the duration of the raffle in seconds
        // if the difference in seconds is greater than the duration of the raffle, then the raffle is over
        // if the difference in seconds is less than the duration of the raffle, then the raffle is not over
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert RaffleNotOpen();
        }

        // getting a random number in a deterministic way is very hard
        // we'll be working with Chainlink VRF
        // create subscription, funded it and get the VRF Coordinator address then we can make a request

        
        
    }

    // Getter functions
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
