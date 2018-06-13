pragma solidity ^0.4.24;

/**
 * @title Класс для создания случайного целого числа для Solidity
 * @dev Оригинал - https://github.com/PillarDevelopment/PillarLab/blob/master/Contracts/lib/RandomNumber.sol
 */

contract RandomInteger {
	uint public max_numbers; // максимальное количество случайных чисел от 0 до
	uint public shift_block; // сдвиг
	uint public random_number; // случайное число
	
	
	constructor() public {
		max_numbers = 100;
		shift_block = 1;
	}
	
	// Изменяет максимальное количество случайных вариантов
	function setMaxTicketNumber(uint new_max_number) public {
		max_numbers = new_max_number;
	}
	
	// создает случайное число
	function getRandomNumber() public {
		uint base_random = uint(blockhash(block.number - shift_block));
		//shift_block++;
		random_number = base_random%max_numbers;
	}
	
	// Показать рандомное число
	function printRandomNumber() public view returns (uint) {
		return random_number;
	}
	
	// Показать сдвиг
	function getShift() public constant returns (uint) {
		return shift_block;
	}
	
	// Изменить сдвиг
	function setShift(uint256 newShift) public {
		shift_block = newShift;
	}
	
	// оказать номер блока
	function getBlockNumber() public view returns (uint) {
		return block.number;
	}
	
	// Показать хеш блока
	function getBlockhash() public view returns (uint) {
		return uint(blockhash(block.number - shift_block));
	}
}