// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {StableCoin} from "./StableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Engine is ReentrancyGuard {

    using SafeERC20 for IERC20;

    mapping(address token => address priceFeed) private priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private userCollateralDeposits;
    StableCoin private immutable stableCoin;

    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);

    modifier allowedTokens(address token) {
        require(priceFeeds[token] != address(0), "Token not allowed");
        _;
    }

    modifier moreThanZero(uint256 amount) {
        require(amount > 0, "Amount must be greater than zero");
        _;
    }

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address stableCoinAddress) {
        require(stableCoinAddress != address(0), "StableCoin address cannot be zero");
        require(tokenAddresses.length == priceFeedAddresses.length, "Mismatched array lengths");
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        stableCoin = StableCoin(stableCoinAddress);
    }

    function mintStableCoin() external {
        
    }

 
    function DepositCollateralAndMintStableCoin(address tokenCollateralAddress, uint256 amount) external {
       
    }

    /**
        @notice Deposits collateral
        @param tokenCollateralAddress The address of the collateral token
        @param amount The amount of collateral to deposit
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amount) external allowedTokens(tokenCollateralAddress) moreThanZero(amount) nonReentrant {
        
        userCollateralDeposits[msg.sender][tokenCollateralAddress] += amount;
        IERC20(tokenCollateralAddress).safeTransferFrom(msg.sender, address(this), amount);
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amount);
        
    }

    function redeemCollateralForStableCoin(uint256 amount) external {
        stableCoin.burn(amount);
    }

    function redeemCollateral() external {
        
    }

    function burnStableCoin() external {
       
    }

    function liquidate() external {
        
    }

       function getHealthFactor() external view{
        
    }
}
