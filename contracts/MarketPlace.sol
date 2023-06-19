// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "./interface/IMarketPlace.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MarketPlace is
    IMarketPlace,
    ReentrancyGuard,
    ERC721Holder,
    ERC1155Holder,
    Ownable
{
    uint crrentOrderId;
    uint public price = 1 ether;

    mapping(uint => OrderInfo) public orders;

    function createOrder(
        address _targetAddr,
        uint _tokenId,
        uint _amount,
        uint _price
    ) external {
        crrentOrderId++;
        orders[crrentOrderId] = OrderInfo(
            _targetAddr,
            msg.sender,
            address(0),
            _tokenId,
            _amount,
            _price
        );

        emit Order(
            _targetAddr,
            msg.sender,
            crrentOrderId,
            _tokenId,
            _amount,
            _price
        );
    }

    function buyOrder(uint orderId) external payable nonReentrant {
        OrderInfo memory _Order = orders[orderId];
        require(msg.value >= _Order.price);

        (bool sent, ) = payable(_Order.seller).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
        //transfer

        if (_Order.amount > 1) {
            IERC1155(_Order.targetAddr).safeTransferFrom(
                address(this),
                msg.sender,
                _Order.tokenId,
                _Order.amount,
                "0x"
            );
        } else {
            IERC721(_Order.targetAddr).safeTransferFrom(
                address(this),
                msg.sender,
                _Order.tokenId,
                "0x"
            );
        }

        IERC20(_Order.targetAddr).transferFrom(
            msg.sender,
            _Order.seller,
            _Order.price
        );
        emit Order(
            _Order.targetAddr,
            _Order.seller,
            orderId,
            _Order.tokenId,
            _Order.amount,
            _Order.price
        );
        delete orders[orderId];
    }

    function cancelOrder(uint orderId) external {
        require(msg.sender == orders[orderId].seller, "Market: not seller.");
        delete orders[orderId];
    }

    //====================CONFIG==================
    function setPrice(uint _price) external onlyOwner {
        price = _price;
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
