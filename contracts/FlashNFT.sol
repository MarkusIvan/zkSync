// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./interfaces/IFlashNFT.sol";
import "./FlashNFTCore.sol";

pragma solidity 0.8.19;

contract FlashNFT is FlashNFTCore, ERC721Enumerable, IFlashNFT {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _minGasToTransfer,
        address _lzEndpoint
    ) ERC721(_name, _symbol) FlashNFTCore(_minGasToTransfer, _lzEndpoint) {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(FlashNFTCore, ERC721Enumerable, IERC165)
        returns (bool)
    {
        return interfaceId == type(IFlashNFT).interfaceId || super.supportsInterface(interfaceId);
    }

    function _debitFrom(
        address _from,
        uint16,
        bytes memory,
        uint256 _tokenId
    ) internal virtual override {
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "FlashNFT: send caller is not owner nor approved");
        require(ERC721.ownerOf(_tokenId) == _from, "FlashNFT: send from incorrect owner");
        _transfer(_from, address(this), _tokenId);
    }

    function _creditTo(
        uint16,
        address _toAddress,
        uint256 _tokenId
    ) internal virtual override {
        require(!_exists(_tokenId) || (_exists(_tokenId) && ERC721.ownerOf(_tokenId) == address(this)));
        if (!_exists(_tokenId)) {
            _safeMint(_toAddress, _tokenId);
        } else {
            _transfer(address(this), _toAddress, _tokenId);
        }
    }
}
