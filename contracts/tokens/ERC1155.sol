// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract EFAS1155 is ERC1155, Ownable, ERC1155Supply {
    string public name;
    string public baseURI;
    mapping(uint256 => string) private uris;

    address public immutable signer; // 签名地址
    mapping(address => bool) public mintedAddress;

    constructor(
        string memory _name,
        string memory _baseURI
    ) ERC1155("ipfs://hash/{id}.json") {
        name = _name;
        baseURI = _baseURI;
        _mint(msg.sender, 0, 1, "");
        _mint(msg.sender, 1, 100, "");
        _mint(msg.sender, 2, 1, "");
        _mint(msg.sender, 3, 1000000, "");
        _mint(msg.sender, 4, 1000000, "");
    }

    function uri(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(baseURI, Strings.toString(_tokenId), ".json")
            );
    }

    function setURI(string memory newuri) public onlyOwner {
        baseURI = newuri;
    }

    function mint(
        address _account,
        uint256 _id,
        uint256 _amount,
        bytes memory _signature
    ) public onlyOwner {
        bytes32 _msgHash = getMessageHash(_account, _id); // 将_account和_tokenId打包消息
        bytes32 _ethSignedMessageHash = ECDSA.toEthSignedMessageHash(_msgHash); // 计算以太坊签名消息
        require(verify(_ethSignedMessageHash, _signature), "Invalid signature"); // ECDSA检验通过
        require(!mintedAddress[_account], "Already minted!"); // 地址没有mint过
        _mint(_account, _id, _amount, _signature);
        mintedAddress[_account] = true; // 记录mint过的地址
    }

    // 利用ECDSA验证签名并mint
    function mint(
        address _account,
        uint256 _tokenId,
        bytes memory _signature
    ) external {}

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function getMessageHash(
        address _account,
        uint256 _tokenId
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_account, _tokenId));
    }

    // ECDSA验证，调用ECDSA库的verify()函数
    function verify(
        bytes32 _msgHash,
        bytes memory _signature
    ) public view returns (bool) {
        return ECDSA.recover(_msgHash, _signature) == signer;
    }
}
