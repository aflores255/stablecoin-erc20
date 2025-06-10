// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {StableCoin} from "./StableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AggregatorV3Interface} from "./interfaces/AggregatorV3Interface.sol";

contract Engine is ReentrancyGuard {
    using SafeERC20 for IERC20;

    uint256 private constant PRICE_FEED_PRECISION = 1e10;
    uint256 private constant PRECISION = 1e18;
    mapping(address token => address priceFeed) private priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private userCollateralDeposits;
    mapping(address user => uint256 amountMinted) private userStableCoinMinted;
    address[] private collateralTokens;
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
            collateralTokens.push(tokenAddresses[i]);
        }
        stableCoin = StableCoin(stableCoinAddress);
    }

    /**
     * @notice Mints new stable coins
     * @param amount The amount of stable coins to mint
     */
    function mintStableCoin(uint256 amount) external moreThanZero(amount) nonReentrant {
        userStableCoinMinted[msg.sender] += amount;
        _checkHealthFactor(msg.sender);
    }

    function DepositCollateralAndMintStableCoin(address tokenCollateralAddress, uint256 amount) external {}

    /**
     * @notice Deposits collateral
     *     @param tokenCollateralAddress The address of the collateral token
     *     @param amount The amount of collateral to deposit
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amount)
        external
        allowedTokens(tokenCollateralAddress)
        moreThanZero(amount)
        nonReentrant
    {
        userCollateralDeposits[msg.sender][tokenCollateralAddress] += amount;
        IERC20(tokenCollateralAddress).safeTransferFrom(msg.sender, address(this), amount);
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amount);
    }

    function redeemCollateralForStableCoin(uint256 amount) external {
        stableCoin.burn(amount);
    }

    function redeemCollateral() external {}

    function burnStableCoin() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    function getAccountCollateralValue(address user) public view returns (uint256 totalCollateralValue) {
        for (uint256 i = 0; i < collateralTokens.length; i++) {
            address token = collateralTokens[i];
            uint256 amount = userCollateralDeposits[user][token];
            totalCollateralValue += getUsdValue(token, amount);
        }
        return totalCollateralValue;
    }

    function getUsdValue(address token, uint256 amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(priceFeeds[token]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return ((uint256(price) * PRICE_FEED_PRECISION) * amount) / PRECISION;
    }

    function _getUserInfo(address user) private view returns (uint256 totalMinted, uint256 collateralValueInUsd) {
        totalMinted = userStableCoinMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    function _healthFactor(address user) private view returns (uint256) {
        (uint256 totalMinted, uint256 collateralValueInUsd) = _getUserInfo(user);
    }

    function _checkHealthFactor(address user) internal view {
        // Implement health factor check logic
        // This function should calculate the health factor based on user collateral and minted stable coins
        // If the health factor is below a certain threshold, it may trigger liquidation or other actions
    }
}
