import "@matterlabs/hardhat-zksync-deploy";
import "@matterlabs/hardhat-zksync-solc";
import "@matterlabs/hardhat-zksync-verify";

module.exports = {
  zksolc: {
    version: "latest", // Uses latest available in https://github.com/matter-labs/zksolc-bin/
    settings: {
      optimizer:{
        enable:true,
      }
    },
  },
  defaultNetwork: "zkSyncTestnet",
  networks: {
    zkSyncMainnet: {
      url: "https://zksync2-mainnet.zksync.io",
      ethNetwork: "mainnet", // Can also be the RPC URL of the network (e.g. `https://goerli.infura.io/v3/<API_KEY>`)
      zksync: true,
    },
    zkSyncTestnet: {
      url: "https://testnet.era.zksync.dev",
      ethNetwork: "goerli", // RPC URL of the network (e.g. `https://goerli.infura.io/v3/<API_KEY>`)
      zksync: true,
      verifyURL: 'https://zksync2-testnet-explorer.zksync.dev/contract_verification'  // Verification endpoint
    },
    aitdTest: {
      url: "http://http-testnet.aitd.io",
      chainId: 1320,
      gasPrice: 50000000000,
      accounts: [process.env.DEPLOY_PRIVATE_KEY]
    },
    aitdMain: {
      url: "https://walletrpc.aitd.io",
      chainId: 1319,
      gasPrice: 50000000000,
      accounts: [process.env.DEPLOY_PRIVATE_KEY]
    },
  },
  solidity: {
    version: "0.8.17",
  },
};

//npx hardhat compile
//npx hardhat deploy-zksync