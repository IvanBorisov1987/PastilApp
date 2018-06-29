# PillarDev Decentralization Application
## My Decentralized Application

Система устанавливается на базе Linux Ubuntu 16.04
1) [Установка Go-Ethereum](https://geth.ethereum.org/install/);
2) [Установка актуальной версии Go(v.1.7)](https://medium.com/@patdhlk/how-to-install-go-1-8-on-ubuntu-16-04-710967aa53c9)
3) Синхронизация базы данных блокчейна Ethereum;
4) Установка node.js
5) Установка homebrew
6) Установка git lab;
7) [Установка ноды Ethereum;](https://coin-lab.com/ethereum-glava-2-ustanovka-i-zapusk-nody/#gl21) [Command line Options](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options)
8) удаление Geth и установка parity(если нет SSD)
9) [Установка full node bitcoin](https://bitcoin.org/en/full-node#ubuntu-1610)


## Порядок использования truffle для деплоя
1. [Инициализировать проект truffle.](https://truffleframework.com/docs/getting_started/project)

2. [Протестировать.](https://truffleframework.com/docs/getting_started/testing)

3. Задать файл конфигурации:

`module.exports = {
   networks: {
     development: {
       host: "localhost",
       port: 8545,
       network_id: "1337", // Match any network id
     },
     rinkeby: {
           host: "localhost",
           port: 8545,
           from: "0x81Cfe8eFdb6c7B7218DDd5F6bda3AA4cd1554Fd2", // адрес с которого буду деплоить
           network_id: 4,
           gas: 4612388 // Gas limit used for deploys
         }
   }
 };
`

4. Прописать логику деплоя в:
 
1_inintial_migrations.js (оставить неизменной)
  
2_deploy_contracts.js ()

5. синхронизировать цепочку блоков:

`geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal`

6. Запустить Geth с параметрами:

`geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="Адрес"`

7. Ввести пароль, в моем случае MIST.

8. в корневой папке проекта Truffle ввести:

`truffle migrate --network rinkeby`

9. Получить адреса в консоли.

10. При желании можно подключить управление web интрефеус через remix или wallet.ethereum.