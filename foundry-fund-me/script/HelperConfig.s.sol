// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 1. Deploy Mock when we are on a local anvil chain
// 2. Keep tracks of contract address across different chains

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on a local anvil chain, we deploy mocks
    // Otherwise, grab the existing address from the live network

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e18;

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepholiaEthConfig();
        } else if (block.chainid == 421614) {
            activeNetworkConfig = getSepoliaArbConfig();
        } else if (block.chainid == 42161) {
            activeNetworkConfig = getMainnetArbConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepholiaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaEthConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaEthConfig;
    }

    function getSepoliaArbConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaArbConfig = NetworkConfig({
            priceFeed: 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165
        });
        return sepoliaArbConfig;
    }

    function getMainnetArbConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetArbConfig = NetworkConfig({
            priceFeed: 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612
        });
        return mainnetArbConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetEthConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetEthConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
