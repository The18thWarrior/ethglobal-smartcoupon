require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.7",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1
      }
    }
  },
  networks: {
    hardhat: {
    },
    mumbai: {
      url: process.env.NETWORK_URL,
      accounts: [process.env.DEVACCOUNTKEY],
      timeout: 600000,
      gas: 2100000,
      gasPrice: 8000000000,
    }
  },
};
