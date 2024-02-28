import { deployContract } from "./utils";

// An example of a basic deploy script
// It will deploy a Greeter contract to selected network
// as well as verify it on Block Explorer if possible for the network
export default async function () {
  const contractArtifactName = "ProxyNftCounter";

  const constructorArguments = [];

  await deployContract(contractArtifactName, constructorArguments);
}

// npx hardhat deploy-zksync --script deployCounter --network zkSyncTestnetGoerli


// Starting deployment process of "ProxyNftCounter"...
// Estimated deployment cost: 0.0009865016 ETH

// "ProxyNftCounter" was successfully deployed:
//  - Contract address: 0x3Cc46C134005B5E15fd93016E897F160b0b96888
//  - Contract source: contracts/ProxyNftCounter.sol:ProxyNftCounter
//  - Encoded constructor arguments: 0x

// Requesting contract verification...
// Your verification ID is: 52043
// Contract successfully verified on zkSync block explorer!

