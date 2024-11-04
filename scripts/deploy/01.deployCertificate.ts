import { ethers, run } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying VerifiableNFT contract with the account:",
    deployer.address
  );
  const name = "Graduation Diploma Course 20";
  const symbol = "GDC20";
  const baseUri = "https://amber-parallel-falcon-815.mypinata.cloud/ipfs";

  const VerifiableNFT = await ethers.getContractFactory("VerifiableNFT");
  const VerifiableNFTContract = await VerifiableNFT.deploy(
    name,
    symbol,
    baseUri
  );
  await VerifiableNFTContract.waitForDeployment();
  const VerifiableNFTContractDeployed =
    await VerifiableNFTContract.getAddress();

  console.log(
    "VerifiableNFT contract deployed at address: ",
    VerifiableNFTContractDeployed
  );

  await run("verify:verify", {
    address: VerifiableNFTContractDeployed,
    constructorArguments: [name, symbol, baseUri],
    contract: "contracts/VerifiableNFT.sol:VerifiableNFT",
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
