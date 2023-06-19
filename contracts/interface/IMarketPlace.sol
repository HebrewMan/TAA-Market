// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

interface IMarketPlace {
    event Order(
        address indexed targetAddr,
        address indexed seller,
        uint orderId,
        uint tokenId,
        uint amount,
        uint price
    );

    struct OrderInfo {
        address targetAddr;
        address seller;
        address buyer;
        uint tokenId;
        uint amount;
        uint price;
    }

    function createOrder(
        address targetAddr,
        uint tokenId,
        uint amount,
        uint price
    ) external;

    function buyOrder(uint orderId) external payable;

    function cancelOrder(uint orderId) external;
}
