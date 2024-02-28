// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../interfaces/IFlashNFTCore.sol";

pragma solidity 0.8.19;

interface IFlashNFT is IFlashNFTCore, IERC721 {}
