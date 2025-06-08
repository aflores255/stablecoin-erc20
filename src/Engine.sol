// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {StableCoin} from "./StableCoin.sol";

contract Engine {
    StableCoin private stableCoin;

    constructor(address stableCoinAddress) {
        stableCoin = StableCoin(stableCoinAddress);
    }

    function DepositCollateralAndMintStableCoin(address to, uint256 amount) external {
        stableCoin.mint(to, amount);
    }

    function redeemCollateralForStableCoin(uint256 amount) external {
        stableCoin.burn(amount);
    }

    function burnStableCoin() external {
       
    }

    function liquidate() external {
        
    }

       function getHealthFactor() external view{
        
    }
}
