// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract StableCoin is ERC20Burnable, Ownable {
    uint256 public constant INITIAL_SUPPLY = 1000000 * 10 ** 18;

    constructor() ERC20("StableCoin", "STC") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to_, uint256 amount_) external onlyOwner {
        require(to_ != address(0), "Cannot mint to the zero address");
        require(amount_ > 0, "Mint amount must be greater than zero");
        _mint(to_, amount_);
    }

    function burn(uint256 amount_) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        require(balance >= amount_, "Burn amount exceeds balance");
        require(amount_ > 0, "Burn amount must be greater than zero");
        super.burn(amount_);
    }
}
