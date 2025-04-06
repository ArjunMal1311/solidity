// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


// function signature -> transfer(address, uint256)
// function selector -> first 4 bytes of the function signature
// (0xa9059cbb)


contract CallAnything {
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address someAddress, uint256 amount) public {
        s_someAddress = someAddress;
        s_amount = amount;
    }


    function getSelectorOne() public pure returns (bytes4){
        return bytes4(keccak256(bytes("transfer(address,uint256)")));
    } // we get 0xa9059cbb which is the first 4 bytes of the function signature


    function getDataToCallTransfer(address someAddress, uint256 amount) public pure returns(bytes memory){
        return abi.encodeWithSelector(getSelectorOne(), someAddress, amount);
    }

    function callTransferWithBinary(address someAddress, uint256 amount) public returns(bytes4, bool){
        (bool success, bytes memory returnData) = address(this).call(abi.encodeWithSelector(getSelectorOne(), someAddress, amount));
        
        return(bytes4(returnData), success);
    }
    // > We could also use address(this).call(getDataToCallTransfer(someAddress, amount));


}

