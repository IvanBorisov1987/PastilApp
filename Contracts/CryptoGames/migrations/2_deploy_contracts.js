// оригинла из NaviAddress

const NaviAuction = artifacts.require("./NaviAuction.sol");
const NaviProxy = artifacts.require("./NaviProxy.sol");
const NaviToken = artifacts.require("./NaviToken.sol");
const NaviStoreControlls = artifacts.require("./NaviStoreControlls.sol");
const NaviStoreCore = artifacts.require("./NaviStoreCore.sol");
const NaviTokenBurner = artifacts.require("./NaviTokenBurner.sol");

module.exports = function(deployer) {
        // деплоим прохи
	deployer.deploy(NaviProxy).then(function() {
	    // деплоим токен
	    return deployer.deploy(NaviToken);
	    // деплоим бернера
	}).then(function() {
       	return deployer.deploy(NaviTokenBurner, NaviToken.address);
        // деплоим аукцион и араметрами передаем адрес прокси и бернера
     }).then(function() {
  		return deployer.deploy(NaviAuction, NaviProxy.address, NaviTokenBurner.address);
  	    // деплоим стор кор и в качестве парметра передаем прокси
	}).then(function() {
		return deployer.deploy(NaviStoreCore, NaviProxy.address);
        // деплоим стор контролс и в качестве параметра передаем прокси
	}).then(function() {
		return deployer.deploy(NaviStoreControlls, NaviProxy.address);
        // вызываем сеттеры прокси и устанавливаем значения задеплоенных раннее адресов
	}).then(function() {
		return NaviProxy.at(NaviProxy.address).setAuctionAddress(NaviAuction.address);
	}).then(function() {
		return NaviProxy.at(NaviProxy.address).setTokenAddress(NaviToken.address);
	}).then(function() {
		return NaviProxy.at(NaviProxy.address).setStoreCoreAddress(NaviStoreCore.address);
	}).then(function() {
		return NaviProxy.at(NaviProxy.address).setStoreControllsAddress(NaviStoreControlls.address);
	}).then(function(e) {
		console.log('Contracts deployed');
	});
}