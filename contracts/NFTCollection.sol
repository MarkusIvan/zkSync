// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IFlashProxyCounter.sol";

/**
 * @title NFTCollection
 * @dev A contract for managing a collection of ERC721 tokens.
 * This contract allows users to mint NFTs by paying a specified cost.
 * The maximum supply of NFTs and the base URI for metadata can be set by the contract owner.
 * The contract also includes functions for setting the base extension, cost, and counter contract address.
 */
contract NFTCollection is ERC721Enumerable, Ownable {
    using Strings for uint256;

    IFlashProxyCounter public counter;

    // @notice Counter for tracking the ID of the NFTs.
    uint256 public nftIdCounter;

    //@notice baseURI for NFT
    string public baseURI;

    // @notice baseExtension for NFT
    string public baseExtension;

    // @notice cost for minting one NFT
    uint256 public cost;

    //@notice maxSupply for NFT
    uint256 public maxSupply;

    mapping(address => bool) public mintListStatus;

    // ____________________ Events ________________________
    /**
     * @notice Emitted when the maximum supply of the NFT collection is set.
     * @param newMaxSupply The new maximum supply value.
     */
    event MaxSupplySet(uint256 indexed newMaxSupply);

    /**
     * @notice Emitted when the base extension for the NFT collection is set.
     * @param newBaseExtension The new base extension value.
     */
    event BaseExtensionSet(string indexed newBaseExtension);

    /**
     * @notice Emitted when the base URI for the NFT collection is set.
     * @param newBaseURI The new base URI.
     */
    event BaseURISet(string indexed newBaseURI);

    /**
     * @notice Emitted when the cost of the NFT collection is set.
     * @param newCost The new cost of the NFT collection.
     */
    event CostSet(uint256 indexed newCost);

    /**
     * @notice Emitted when new tokens are minted.
     *
     * @param to The address that receives the minted tokens.
     * @param amount The amount of tokens minted.
     */
    event Minted(address indexed to, uint256 amount);

    /**
     * @notice Emitted when the counter address is set.
     * @param counterAddr The address of the counter contract.
     */
    event CounterSet(address indexed counterAddr);

    /**
     * @notice Emitted when an address withdraws an amount from the contract.
     * @param owner The address of the account that withdrew the amount.
     * @param amount The amount that was withdrawn.
     */
    event Withdrawn(address indexed owner, uint256 amount);

    // ____________________ Errors ________________________
    /// @notice Revers when the maximum supply is reached.
    error OutOfSupply();

    ///@notice Revers when the cost is set to 0.
    error InvalidAmount();

    /// @notice Revers when the base URI is set to an empty string.
    error EmptyBaseURI();

    ///@notice Revers when the base extension is set to an empty string.
    error EmptyBaseExtension();

    /// @notice Revers when the cost is set to 0.
    error LowCostValue();

    ///@notice Revers when the transaction ends with failure.
    error TransactionEndedWithFailure();

    ///@notice Revers when the counter address is set to 0.
    error ZeroAddress();

    // ____________________ Constructor ________________________
    /**
     * @notice Constructor function for NFTCollection contract.
     * @param baseURI_ The base URI for the NFT metadata.
     * @param baseExtension_ The base extension for the NFT metadata.
     * @param maxSupply_ The maximum supply of NFTs that can be minted.
     * @param cost_ The cost to mint a single NFT.
     * @param counter_ The address of the IFlashProxyCounter contract.
     */
    constructor(
        string memory baseURI_,
        string memory baseExtension_,
        uint256 maxSupply_,
        uint256 cost_,
        IFlashProxyCounter counter_
    ) ERC721("FLASH NFT", "FLNFT") {
        if (bytes(baseURI_).length == 0) revert EmptyBaseURI();
        baseURI = baseURI_;

        if (bytes(baseExtension_).length == 0) revert EmptyBaseExtension();
        baseExtension = baseExtension_;

        if (maxSupply_ == 0) revert InvalidAmount();

        maxSupply = maxSupply_;

        if (cost_ == 0) revert InvalidAmount();
        cost = cost_;

        if (address(counter_) == address(0)) revert ZeroAddress();
        counter = counter_;

        counter.setRole(address(this), msg.sender);
    }

    // ____________________ External functions  ________________________
    /**
     * @notice Mints a new NFT to the caller of the function.
     * The caller must send enough Ether to cover the cost of minting.
     * If the cost is not met, a `LowCostValue` error is thrown.
     * If the maximum supply of NFTs has been reached, an `OutOfSupply` error is thrown.
     * The Ether sent by the caller is transferred to the contract owner.
     * The NFT is minted to the caller's address using the `_safeMint` function.
     * If the caller is minting an NFT for the first time, their `mintListStatus` is set to `true`
     * and their counter is incremented using the `counter.incrementCounter` function.
     * Emits a `Minted` event with the caller's address and the ID of the minted NFT.
     */
    function mint() external payable {
        if (msg.value < cost) revert LowCostValue();

        unchecked {
            nftIdCounter++;
        }

        if (nftIdCounter > maxSupply) revert OutOfSupply();
        
        _safeMint(msg.sender, nftIdCounter);

        if (!mintListStatus[msg.sender]) {
            mintListStatus[msg.sender] = true;
            counter.incrementCounter(msg.sender);
        }

        emit Minted(msg.sender, nftIdCounter);
    }

    /**
     * @notice Sets the counter contract address.
     * @param _counter The address of the IFlashProxyCounter contract.
     * @notice Only the contract owner can call this function.
     * @notice Reverts if the provided counter address is zero.
     */
    function setCounter(IFlashProxyCounter _counter) external onlyOwner {
        if (address(_counter) == address(0)) revert ZeroAddress();

        counter = _counter;
        emit CounterSet(address(_counter));
    }

    /**
     * @notice Sets the base URI for the NFT collection.
     * @param newBaseURI The new base URI to set.
     * @notice Only the contract owner can call this function.
     * @notice The new base URI must not be empty.
     * @notice Emits a `BaseURISet` event with the new base URI.
     */
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        if (bytes(newBaseURI).length == 0) revert EmptyBaseExtension();

        baseURI = newBaseURI;

        emit BaseURISet(newBaseURI);
    }

    /**
     * @notice Sets the base extension for the NFT collection.
     * @param newBaseExtension The new base extension to be set.
     * @notice Only the contract owner can call this function.
     * @notice The new base extension cannot be an empty string.
     * @notice Emits a `BaseExtensionSet` event with the new base extension.
     */
    function setBaseExtension(string memory newBaseExtension) external onlyOwner {
        if (bytes(newBaseExtension).length == 0) revert EmptyBaseExtension();

        baseExtension = newBaseExtension;

        emit BaseExtensionSet(newBaseExtension);
    }

    /**
     * @notice Sets the maximum supply of the NFT collection.
     * @param newMaxSupply The new maximum supply value.
     * @notice Only the owner of the contract can call this function.
     * @notice If the new maximum supply is set to 0, it will revert with an InvalidAmount error.
     * @notice Emits a MaxSupplySet event with the new maximum supply value.
     */
    function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
        if (newMaxSupply == 0) revert InvalidAmount();

        maxSupply = newMaxSupply;

        emit MaxSupplySet(newMaxSupply);
    }

    /**
     * @notice Sets the cost of the NFT collection.
     * @param newCost The new cost to set.
     * @notice Only the contract owner can call this function.
     * @notice The new cost must be greater than zero.
     * @notice Emits a `CostSet` event with the new cost.
     */
    function setCost(uint256 newCost) external onlyOwner {
        if (newCost == 0) revert InvalidAmount();

        cost = newCost;

        emit CostSet(newCost);
    }

    /**
     * @notice Withdraws the contract balance and transfers it to the owner.
     * Only the contract owner can call this function.
     * If the transaction fails, it reverts with a custom error message.
     */
    function withdraw() public payable onlyOwner {
        // This will payout the owner all of the contract balance.
        // Do not remove this otherwise you will not be able to withdraw the funds.
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        if (!os) revert TransactionEndedWithFailure();

        emit Withdrawn(owner(), address(this).balance);
    }

    // ____________________ External view functions ____________________

    /**
     * @notice Returns the URI for a given token ID.
     * @param tokenId The ID of the token to retrieve the URI for.
     * @return The URI string for the given token ID.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension)) : "";
    }
}