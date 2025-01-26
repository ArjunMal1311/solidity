//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract FactoryHelp {
    FundMe public fundMe;

    constructor(address priceFeed) {
        fundMe = new FundMe(priceFeed);
    }
}

contract FundMeRevertWithdraw is Test {
    FundMe fundMe;

    function setUp() external {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        FactoryHelp fh = new FactoryHelp(ethUsdPriceFeed);
        fundMe = fh.fundMe();
    }

    function testWithdrawRevert() external {
        bytes memory customError = abi.encodeWithSignature(
            "FundMe__FailWithdraw()"
        );
        address owner = fundMe.getOwner();
        vm.expectRevert(customError);
        vm.prank(owner);
        fundMe.withdraw();
    }
}
