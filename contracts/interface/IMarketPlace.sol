// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

interface IMarketPlace {
    event SoldOrder(
        address indexed _seller,
        address indexed _payment,
        address indexed _nft,
        uint _orderId,
        uint _tokenId,
        uint _amount,
        uint _price
    );

    event BoughtOrder(
        address indexed _seller,
        address indexed _buyer,
        address indexed _payment,
        address _nft,
        uint _orderId,
        uint _tokenId,
        uint _amount,
        uint _price
    );

    event CanceledOrder(address indexed seller, uint orderId);

    struct OrderInfo {
        address seller;
        address targetAddr;
        address payment;
        uint tokenId;
        uint amount;
        uint price;
    }

    function createOrder(
        address targetAddr,
        address payment,
        uint tokenId,
        uint amount,
        uint price
    ) external;

    function buyOrder(uint orderId) external payable;

    function cancelOrder(uint orderId) external;

    // function
}
