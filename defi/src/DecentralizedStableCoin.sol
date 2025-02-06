// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    // We are using ERC20Burnable because it has burn function and thus we need to use its constructor as well
    // Ownable grants exclusive control over specific functions to the owner of the contract

    // ERC-20 token standard implementation, which includes basic functions like transferring tokens, checking balances, and approving transfers.

    error DecentralizedStableCoin__MustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin__NotZeroAddress();

    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(msg.sender) {}

    // permanently removing the NFT from the circulation
    function burn(uint256 amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (amount <= 0) revert DecentralizedStableCoin__MustBeMoreThanZero();
        if (amount > balance) revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        
        super.burn(amount); // run the function of parent class
    }


    // Creating and registering new NFT to blockchain
    function mint(address to, uint256 amount) external onlyOwner returns (bool) {
        if (to == address(0)) revert DecentralizedStableCoin__NotZeroAddress();
        if (amount <= 0) revert DecentralizedStableCoin__MustBeMoreThanZero();
        
        _mint(to, amount); // inherited from ERC20 to mint specified tokens and assign them the address
        return true;
    }
}
