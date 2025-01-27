// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Raffle
 * @author Arjun Malhotra
 * @notice This contract is a simple raffle contract
 */

import "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Raffle is VRFConsumerBaseV2Plus {
    // Errors
    error SendMoreToEnterRaffle();
    error Raffle__RaffleNotOpen();
    error Raffle__TransferFailed();
    error Raffle__UpkeepNotNeeded();

    // Events
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    // Enums
    enum RaffleState {
        OPEN, // 0
        CALCULATING // 1
    }

    // State Variables
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    // We wont be able to change the entrance fee once the contract is deployed
    uint256 public immutable i_entranceFee;
    address[] private s_players; // not constant or immutable since players can be added and removed
    uint256 public immutable i_interval; // duration of the raffle in seconds
    uint256 public s_lastTimeStamp;
    address private immutable i_vrfCoordinatorV2;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint32 private immutable i_numWords;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    // Running the constructor of VRFConsumerBaseV2Plus as well
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinatorV2,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit,
        uint32 numWords
    ) VRFConsumerBaseV2Plus(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinatorV2 = vrfCoordinatorV2;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        i_numWords = numWords;

        s_raffleState = RaffleState.OPEN;
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

        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
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

    function checkUpKeep(
        bytes memory
    ) public view returns (bool upkeepNeeded, bytes memory) {
        bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;

        upkeepNeeded = (timeHasPassed && isOpen && hasBalance && hasPlayers);
        return (upkeepNeeded, "0x0");
    }

    function performUpkeep(bytes calldata) external {
        (bool upkeepNeeded, ) = checkUpKeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded();
        }

        // 1. Pick a random winner
        // 2. Use Random Number to pick a winner
        // 3. Be automatically called after a certain amount of time

        // block.timestamp is the current timestamp of the block
        // block.timestamp - s_lastTimeStamp is the difference in seconds between the current timestamp and the last timestamp
        // i_interval is the duration of the raffle in seconds
        // if the difference in seconds is greater than the duration of the raffle, then the raffle is over
        // if the difference in seconds is less than the duration of the raffle, then the raffle is not over
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert Raffle__RaffleNotOpen();
        }

        s_raffleState = RaffleState.CALCULATING;

        // getting a random number in a deterministic way is very hard
        // we'll be working with Chainlink VRF
        // create subscription, funded it and get the VRF Coordinator address then we can make a request

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: i_numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });

        // we are passing the request struct to the requestRandomWords function
        // where keyhash is the gaslane which is some gas price to work with the chain
        // subId is the subscription id which is the id of the subscription we created
        // requestConfirmations is the number of confirmations we want to wait for the random number
        // callbackGasLimit is the gas limit for the callback function
        // numWords is the number of random words we want to get
        // extraArgs is the extra arguments we want to pass to the request
        // s_vrfCoordinator.requestRandomWords(request);

        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
        // we gonna call request random words with the request struct
        // and get reqID and once we send this request to the chain
        // chain link node will wait for some block confirmations
        // and call back fulfillrandomwords function
        // and get our random number
    }

    // Getter functions
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    // Why we need to override the fulfillRandomWords function?
    // abstract contract VRFConsumerBaseV2Plus has a function called fulfillRandomWords
    // we need to override it and implement it in our contract

    // if you are going to use VRF, you need to use the below function

    // CEI : Checks, Effects, Interactions
    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {
        // Checks
        // s_player = 10
        // rng = 12
        // 12% 10 = 2
        // indexOfWinner = 2
        // recentWinner = s_players[2]
        // s_recentWinner = recentWinner

        // Effects
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = payable(s_players[indexOfWinner]);
        s_recentWinner = recentWinner;

        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0); // reset the players array

        s_lastTimeStamp = block.timestamp;

        // Interactions (External Contract Interaction)
        (bool success, ) = recentWinner.call{value: address(this).balance}("");

        if (!success) {
            revert Raffle__TransferFailed();
        }
        emit WinnerPicked(recentWinner);
    }
}
