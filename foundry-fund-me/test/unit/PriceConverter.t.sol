//SPDX-License-Identifier:MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConvertorTest is Test {
    // using PriceConverter for uint256;

    uint256 public constant ETH_AMOUNT = 1e18;

    AggregatorV3Interface priceFeed;

    function setUp() external {
        HelperConfig hc = new HelperConfig();
        priceFeed = AggregatorV3Interface(hc.activeNetworkConfig());
    }

    function testConversionRate() external {
        uint256 ethAmounInUsd = PriceConverter.getConversionRate(
            ETH_AMOUNT,
            priceFeed
        );

        (, int256 price, , , ) = priceFeed.latestRoundData();

        assertEq(
            (uint256(price) * 10000000000 * ETH_AMOUNT) / 1e18,
            ethAmounInUsd
        );
    }
}
