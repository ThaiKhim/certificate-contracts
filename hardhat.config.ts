import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const accounts = process.env.PRIVATE_KEY
  ? process.env.PRIVATE_KEY.replace(" ", "").split(",")
  : undefined;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 999999,
          },
        },
      },
    ],
  },
  defaultNetwork: process.env.NETWORK || "vku_chain",

  networks: {
    hardhat: { allowUnlimitedContractSize: true },
    vku_chain: {
      url: process.env.RPC_URL ?? "http://34.81.113.222:8549/",
      chainId: 6660002,
      accounts: accounts,
      gasPrice: 10000000000,
    },
  },
  etherscan: {
    apiKey: {
      vku_chain: "Rxqgq500k3xPFvz9GrLghBNrcMJTvqXZDJgPYBfveKFkMDJjCX",
    },
    customChains: [
      {
        network: "vku_chain",
        chainId: 6660002,
        urls: {
          apiURL: "http://34.81.113.222//api",
          browserURL: "http://34.81.113.222/",
        },
      },
    ],
  },
};

export default config;
