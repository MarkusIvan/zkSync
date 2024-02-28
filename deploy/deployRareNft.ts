import { deployContract } from "./utils";

// An example of a basic deploy script
// It will deploy a Greeter contract to selected network
// as well as verify it on Block Explorer if possible for the network
export default async function () {
  const contractArtifactName = "FlashRareNFT";
  const counterAddress = "0x3c2269811836af69497E5F486A85D7316753cf62";
  const layerZeroEndpoint = "0x3c2269811836af69497E5F486A85D7316753cf62";

  const _minGasToTransfer = 100000;
  const _layerZeroEndpoint = layerZeroEndpoint;
  const _startMintId = 0;
  const _endMintId = 100;
  const _counter = counterAddress;
  const _minimalCountAmountForEachContracts = [5, 10, 15, 20];
  const rareUris = [
    "https://ipfs/QmX1gTFabPZx8AtmHk3JAr1vNXJLebHmSWx3bMLePXTTnC/",
    "https://ipfs/QmX1gTFabPZx8AtmHk3JAr1vNXJLebHmSWx3bMLePXTTnC/",
    "https://ipfs/QmX1gTFabPZx8AtmHk3JAr1vNXJLebHmSWx3bMLePXTTnC/",
    "https://ipfs/QmX1gTFabPZx8AtmHk3JAr1vNXJLebHmSWx3bMLePXTTnC/",
  ];

  for (let i = 0; i < 4; i++) {
    const constructorArguments = [
      _minGasToTransfer,
      _layerZeroEndpoint,
      _startMintId,
      _endMintId,
      _counter,
      _minimalCountAmountForEachContracts[i],
      rareUris[i],
    ];

    await deployContract(contractArtifactName, constructorArguments);
  }
}

// npx hardhat deploy-zksync --script deployRareNft --network zkSyncTestnetGoerli


// Starting deployment process of "FlashRareNFT"...
// Estimated deployment cost: 0.00598691 ETH

// "FlashRareNFT" was successfully deployed:
//  - Contract address: 0xC7159C1F0d30Fb2aaDDdC248304BF0C016900924
//  - Contract source: contracts/FlashRareNFT.sol:FlashRareNFT
//  - Encoded constructor arguments: 0x00000000000000000000000000000000000000000000000000000000000186a00000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000640000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000003c68747470733a2f2f697066732f516d58316754466162505a783841746d486b334a417231764e584a4c6562486d53577833624d4c65505854546e432f00000000

// Requesting contract verification...
// Your verification ID is: 52064

// Your verification request has been sent, but our servers are currently overloaded and we could not confirm that the verification was successful.
// Please try one of the following options:
//   1. Use the your verification request ID (52064) to check the status of the pending verification process by typing the command 'yarn hardhat verify-status --verification-id 52064'
//   2. Manually check the contract's code on the zksync block explorer: https://explorer.zksync.io/
//   3. Run the verification process again
  
// Contract successfully verified on zkSync block explorer!

// Starting deployment process of "FlashRareNFT"...
// Estimated deployment cost: 0.0001826408 ETH

// "FlashRareNFT" was successfully deployed:
//  - Contract address: 0xE3aC0f4Fffe315df12bebAf28b79F99D95908D24
//  - Contract source: contracts/FlashRareNFT.sol:FlashRareNFT
//  - Encoded constructor arguments: 0x00000000000000000000000000000000000000000000000000000000000186a00000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000640000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000003c68747470733a2f2f697066732f516d58316754466162505a783841746d486b334a417231764e584a4c6562486d53577833624d4c65505854546e432f00000000

// Requesting contract verification...
// Your verification ID is: 52065

// Your verification request has been sent, but our servers are currently overloaded and we could not confirm that the verification was successful.
// Please try one of the following options:
//   1. Use the your verification request ID (52065) to check the status of the pending verification process by typing the command 'yarn hardhat verify-status --verification-id 52065'
//   2. Manually check the contract's code on the zksync block explorer: https://explorer.zksync.io/
//   3. Run the verification process again
  
// Contract successfully verified on zkSync block explorer!

// Starting deployment process of "FlashRareNFT"...
// Estimated deployment cost: 0.0001826408 ETH

// "FlashRareNFT" was successfully deployed:
//  - Contract address: 0xE75Ac8fAcab6CA3da901029c20415EdA3956BB74
//  - Contract source: contracts/FlashRareNFT.sol:FlashRareNFT
//  - Encoded constructor arguments: 0x00000000000000000000000000000000000000000000000000000000000186a00000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000640000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000000f00000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000003c68747470733a2f2f697066732f516d58316754466162505a783841746d486b334a417231764e584a4c6562486d53577833624d4c65505854546e432f00000000

// Requesting contract verification...
// Your verification ID is: 52066

// Your verification request has been sent, but our servers are currently overloaded and we could not confirm that the verification was successful.
// Please try one of the following options:
//   1. Use the your verification request ID (52066) to check the status of the pending verification process by typing the command 'yarn hardhat verify-status --verification-id 52066'
//   2. Manually check the contract's code on the zksync block explorer: https://explorer.zksync.io/
//   3. Run the verification process again
  
// Contract successfully verified on zkSync block explorer!

// Starting deployment process of "FlashRareNFT"...
// Estimated deployment cost: 0.0001826408 ETH

// "FlashRareNFT" was successfully deployed:
//  - Contract address: 0x7D56adf6620Ad77E03A47544EFE63808A8c35890
//  - Contract source: contracts/FlashRareNFT.sol:FlashRareNFT
//  - Encoded constructor arguments: 0x00000000000000000000000000000000000000000000000000000000000186a00000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000640000000000000000000000003c2269811836af69497e5f486a85d7316753cf62000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000003c68747470733a2f2f697066732f516d58316754466162505a783841746d486b334a417231764e584a4c6562486d53577833624d4c65505854546e432f00000000

// Requesting contract verification...
// Your verification ID is: 52067

// Your verification request has been sent, but our servers are currently overloaded and we could not confirm that the verification was successful.
// Please try one of the following options:
//   1. Use the your verification request ID (52067) to check the status of the pending verification process by typing the command 'yarn hardhat verify-status --verification-id 52067'
//   2. Manually check the contract's code on the zksync block explorer: https://explorer.zksync.io/
//   3. Run the verification process again
  
// Contract successfully verified on zkSync block explorer!
// aiv@aiv:~/MyGit/PRO/NFT Bridges/flashZk/zkSync$ 