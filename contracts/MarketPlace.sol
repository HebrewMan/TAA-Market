// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "./interfaces/IMarketPlace.sol";
import "./utils/VerifyERCType.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MarketPlace is
    IMarketPlace,
    ReentrancyGuard,
    ERC721Holder,
    ERC1155Holder,
    Ownable,
    VerifyERCType
{
    uint crrentOrderId;

    mapping(uint => OrderInfo) public orders;

    function createOrder(
        address _nftAddr,
        address _payment,
        uint _tokenId,
        uint _price
    ) external {
        crrentOrderId++;
        orders[crrentOrderId] = OrderInfo(
            msg.sender,
            _nftAddr,
            _payment,
            _tokenId,
            _price
        );
        emit CreatedOrder(
            msg.sender,
            _nftAddr,
            _payment,
            crrentOrderId,
            _tokenId,
            _price
        );
    }

    function buyOrder(uint orderId) external payable nonReentrant {
        OrderInfo memory _Order = orders[orderId];
        require(verifyByAddress(_Order.nftAddr) != 20, "nftAddr is error.");
        require(msg.value >= _Order.price);

        if (verifyByAddress(_Order.nftAddr) == 1155) {
            IERC1155(_Order.nftAddr).safeTransferFrom(
                address(this),
                msg.sender,
                _Order.tokenId,
                1,
                "0x"
            );
        } else {
            IERC721(_Order.nftAddr).safeTransferFrom(
                address(this),
                msg.sender,
                _Order.tokenId,
                "0x"
            );
        }

        IERC20(_Order.nftAddr).transferFrom(
            msg.sender,
            _Order.seller,
            _Order.price
        );
        emit BoughtOrder(
            _Order.seller,
            msg.sender,
            _Order.payment,
            _Order.nftAddr,
            crrentOrderId,
            _Order.tokenId,
            _Order.price
        );
        delete orders[orderId];
    }

    function cancelOrder(uint _orderId) external {
        require(msg.sender == orders[_orderId].seller, "Market: not seller.");
        delete orders[_orderId];
    }

    function getOrder(uint _orderId) external view returns (OrderInfo memory) {
        return orders[_orderId];
    }

    //====================CONFIG==================
    function setPrice(uint _price) external onlyOwner {}

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
