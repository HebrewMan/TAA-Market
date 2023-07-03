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
    uint public crrentOrderId;

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

        if (verifyByAddress(_nftAddr) == 1155) {
            IERC1155(_nftAddr).safeTransferFrom(
                msg.sender,
                address(this),
                _tokenId,
                1,
                "0x"
            );
        } else {
            IERC721(_nftAddr).safeTransferFrom(
                msg.sender,
                address(this),
                _tokenId,
                "0x"
            );
        }

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
        if(_Order.payment == address(0)){
            require(msg.value >= _Order.price,"Insufficient balance in ether.");
        }

        if (verifyByAddress(_Order.nftAddr) == 1155) {
            IERC1155(_Order.nftAddr).safeTransferFrom(
                address(this),
                msg.sender,
                _Order.tokenId,
                1,
                "0x"
            );
        } else {
         
            console.log("==================",_Order.nftAddr);

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
        if (verifyByAddress(orders[_orderId].nftAddr) == 1155) {
            IERC1155(orders[_orderId].nftAddr).safeTransferFrom(
                address(this),
                msg.sender,
                orders[_orderId].tokenId,
                1,
                "0x"
            );
        } else {
            IERC721(orders[_orderId].nftAddr).safeTransferFrom(
                address(this),
                msg.sender,
                orders[_orderId].tokenId,
                "0x"
            );
        }
        delete orders[_orderId];
    }

    //====================CONFIG==================
    function setPrice(uint _price) external onlyOwner {}

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
