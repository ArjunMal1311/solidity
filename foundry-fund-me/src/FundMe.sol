// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    error FundMe__NotOwner();
    error FundMe__NotEnoughEth();
    error FundMe__FailWithdraw();

    event Funded(address indexed sender, uint256 indexed amount);
    event Withdraw(uint256 indexed amount);

    mapping(address => uint256) private s_addressToAmountFunded; // private makes it more gas efficient
    address[] private s_funders;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed;

    constructor(address _priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable {
        if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD) {
            revert FundMe__NotEnoughEth();
        }

        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);

        emit Funded(msg.sender, msg.value); //events are used to log the state of the contract, these logs can be be listened to by external applications or used to track contract activity
        // they can't be read by smart contracts only by external application
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function withdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;

        // Made it efficient by calling the length from funders array from the storage only once
        // rather than using s_funders.length in the for loop

        // Remember calling the length of the array from storage is expensive
        // so we should avoid it as much as possible
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        delete s_funders;
        s_funders = new address[](0);

        uint256 amount = address(this).balance;
        (bool callSuccess, ) = payable(msg.sender).call{value: amount}("");
        if (!callSuccess) {
            revert FundMe__FailWithdraw();
        }

        emit Withdraw(amount);
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    //** view / pure functions (getter) */

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunders(uint256 funderIndex) external view returns (address) {
        return s_funders[funderIndex];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getLengthOfFunders() external view returns (uint256) {
        return s_funders.length;
    }
}