// SPDX-License-Identifier: MIT

import "./interfaces/IFlashProxyCounter.sol";
import "./FlashNFT.sol";

pragma solidity 0.8.19;

contract FlashRareNFT is FlashNFT {
    IFlashProxyCounter public counter;

    uint256 minimalCountAmount;

    uint256 public fee = 0.00001 ether;

    uint256 public nextMintId;
    uint256 public maxMintId;

    string public baseURI;

    /**
     * @notice  A mapping to keep track of the status of minters.
     */
    mapping(address => bool) public minters;

    /**
     * @notice  Event emitted when a new NFT is minted.
     * @param minter The address of the minter.
     * @param id The ID of the minted NFT.
     */
    event Minted(address indexed minter, uint256 indexed id);

    /// @param _layerZeroEndpoint handles message transmission across chains
    /// @param _startMintId the starting mint number on this chain
    /// @param _endMintId the max number of mints on this chain
    constructor(
        uint256 _minGasToTransfer,
        address _layerZeroEndpoint,
        uint256 _startMintId,
        uint256 _endMintId,
        IFlashProxyCounter _counter,
        uint256 _minimalCountAmount, 
        string memory baseURI_
    ) FlashNFT("FLASH Rare NFT", "FRNFT", _minGasToTransfer, _layerZeroEndpoint) {
        nextMintId = _startMintId;
        maxMintId = _endMintId;
        counter = _counter;
        minimalCountAmount = _minimalCountAmount;
        baseURI = baseURI_;
    }

    /**
     * @dev Allows a user to mint a rare NFT by paying a fee and meeting certain conditions.
     * @notice The user must send enough ether as fee, have collected a sufficient amount of NFTs,
     * and not have already minted a rare NFT.
     * Emits a `Minted` event upon successful minting.
     * Reverts if the user does not send enough ether, has already minted a rare NFT,
     * or does not have a sufficient amount of collected NFTs.
     */
    function mint() external payable {
        require(msg.value >= fee, "Not enough ether sent");
        require(nextMintId <= maxMintId, "Too many, bruv");
        
        uint256 collectedNftAmount = counter.getCount(msg.sender);
        require(collectedNftAmount >= minimalCountAmount, "Not enough NFTs");
        require(minters[msg.sender] == false, "Already minted");

        uint256 newId = nextMintId;
        nextMintId++;

        _safeMint(msg.sender, newId);

        minters[msg.sender] = true;

        emit Minted(msg.sender, newId);
    }

    function estimateGasBridgeFee(
        uint16 _dstChainId,
        bool _useZro,
        bytes memory _adapterParams
    ) public view virtual returns (uint256 nativeFee, uint256 zroFee) {
        bytes memory payload = abi.encode(msg.sender, 0);
        return lzEndpoint.estimateFees(_dstChainId, payable(address(this)), payload, _useZro, _adapterParams);
    }

    function bridgeGas(
        uint16 _dstChainId,
        address _zroPaymentAddress,
        bytes memory _adapterParams
    ) public payable {
        _checkGasLimit(_dstChainId, FUNCTION_TYPE_SEND, _adapterParams, dstChainIdToTransferGas[_dstChainId]);
        _lzSend(
            _dstChainId,
            abi.encode(msg.sender, 0),
            payable(address(this)),
            _zroPaymentAddress,
            _adapterParams,
            msg.value
        );
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        return string(abi.encodePacked(_baseURI(), Strings.toString(id), ".json"));
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function setFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        baseURI = baseURI_;
    }
}
