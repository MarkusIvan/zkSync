import { deployContract } from "./utils";

// An example of a basic deploy script
// It will deploy a Greeter contract to selected network
// as well as verify it on Block Explorer if possible for the network
export default async function () {
  const contractArtifactName = "WhaleTest";
  
  const _minGasToTransfer = 40000;
  const _layerZeroEndpoint = "0x3c2269811836af69497E5F486A85D7316753cf62";
  const _startMintId = 1;
  const _endMintId = 1000000;
  const constructorArguments = [
    _minGasToTransfer,
    _layerZeroEndpoint,
    _startMintId,
    _endMintId,
  ];

  await deployContract(contractArtifactName, constructorArguments);
}

// npx hardhat deploy-zksync --script deploy 
