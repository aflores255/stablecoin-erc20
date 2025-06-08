// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract StableCoin is ERC20Burnable, Ownable {

    /**
        @notice constructor for the StableCoin contract
        @dev Initializes the ERC20 token with a name and symbol, owned by the deployer.
    */
    constructor() ERC20("StableCoin", "STC") Ownable(msg.sender) {
    }

    /**
        @notice mints new tokens to a specified address
        @param to_ The address to which the tokens will be minted
        @param amount_ The amount of tokens to mint
        @dev Only the owner can mint new tokens. Reverts if the address is zero or the amount is zero.
    */
    function mint(address to_, uint256 amount_) external onlyOwner {
        require(to_ != address(0), "Cannot mint to the zero address");
        require(amount_ > 0, "Mint amount must be greater than zero");
        _mint(to_, amount_);
    }

    /**
        @notice burns tokens from the caller's account
        @param amount_ The amount of tokens to burn
        @dev Only the owner can burn tokens. Reverts if the burn amount exceeds the caller's balance.
    */
    function burn(uint256 amount_) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        require(balance >= amount_, "Burn amount exceeds balance");
        require(amount_ > 0, "Burn amount must be greater than zero");
        super.burn(amount_);
    }


}
