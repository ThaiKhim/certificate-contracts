import { ethers, run } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying CerifiableNFT contract with the account:",
    deployer.address
  );
  const name = "Graduation Diploma Course 20";
  const symbol = "GDC20";
  const baseUri = "https://amber-parallel-falcon-815.mypinata.cloud/ipfs";

  const CerifiableNFT = await ethers.getContractFactory("CerifiableNFT");
  const CerifiableNFTContract = await CerifiableNFT.deploy(
    name,
    symbol,
    baseUri
  );
  await CerifiableNFTContract.waitForDeployment();
  const CerifiableNFTContractDeployed =
    await CerifiableNFTContract.getAddress();

  console.log(
    "CerifiableNFT contract deployed at address: ",
    CerifiableNFTContractDeployed
  );

  await run("verify:verify", {
    address: CerifiableNFTContractDeployed,
    constructorArguments: [name, symbol, baseUri],
    contract: "contracts/CerifiableNFT.sol:CerifiableNFT",
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
