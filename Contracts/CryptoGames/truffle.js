/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
};



require('dotenv').config();
require('babel-register');
require('babel-polyfill');
const Web3 = require('web3');

const HDWalletProvider = require('truffle-hdwallet-provider');

const providerWithMnemonic = (mnemonic, rpcEndpoint) =>
  new HDWalletProvider(mnemonic, rpcEndpoint);

const infuraProvider = network => providerWithMnemonic(
  process.env.MNEMONIC_DEPLOY || '',
  `https://${network}.infura.io/${process.env.INFURA_API_KEY}`
);

const web3 = new Web3('');
const gasPrice = web3.toWei(process.env.GAS_PRICE_GWEI, "gwei");

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      gas: 6700000,
      network_id: '*', // eslint-disable-line camelcase
    },
    rinkeby: {
               host: "localhost",
               port: 8545,
               from: "0x81Cfe8eFdb6c7B7218DDd5F6bda3AA4cd1554Fd2", // unblocked address for deploy
               network_id: 4,
               gas: 4612388 // Gas limit
             },
    live: {
      provider: infuraProvider('mainnet'),
      network_id: 1, // eslint-disable-line camelcase
      gasPrice: gasPrice,
      gas: 6700000
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};