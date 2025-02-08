// SPDX-License-Identifier: MIT

// What are the invariants? 
// Properties that should always be true, regardless of the inputs.

// 1. The total supply of DSC should be less than or equal to the total collateral value.
// 2. Getter view functions should never revert.


pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";
import {Handler} from "./Handler.t.sol";

contract InvariantsTest is StdInvariant, Test {
    DeployDSC deployer;
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    HelperConfig config;
    address weth;
    address wbtc;
    Handler handler;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (,,weth, wbtc,) = config.activeNetworkConfig();
        // targetContract(address(dsce));

        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
    }

    function invariant_totalSupplyOfDSCShouldBeLessThanTotalCollateralValue() public view {
        uint256 totalSupply = dsc.totalSupply();

        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
        uint256 totalBtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

        uint256 wethUsdValue = dsce.getUsdValue(weth, totalWethDeposited);
        uint256 btcUsdValue = dsce.getUsdValue(wbtc, totalBtcDeposited);

        console.log("wethUsdValue", wethUsdValue);
        console.log("btcUsdValue", btcUsdValue);
        console.log("totalSupply", totalSupply);
        console.log("Times Mint called", handler.timesMintIsCalled());

        assert(wethUsdValue + btcUsdValue >= totalSupply);
    }

    function invariant_gettersShouldNotRevert() public view {
        dsce.getLiquidationBonus();
        dsce.getPrecision();
    }
    
    
}
