pragma solidity ^0.4.24;

contract Random {
	uint public max_ticket_number;
	uint public shift_block;
	uint public winner_number;
	
	constructor() public {
		max_ticket_number = 100;
		shift_block = 1;
	}
	
	function setMaxTicketNumber(uint new_max_ticket_number) public {
		max_ticket_number = new_max_ticket_number;
	}
	
	function getWinnerNumber() public {
		uint base_random = uint(blockhash(block.number - shift_block));
		//shift_block++;
		winner_number = base_random%max_ticket_number;
	}
	
	
	function printWinnerNumber() public view returns (uint) {
		return winner_number;
	}
	
	
	function getShift() public constant returns (uint) {
		return shift_block;
	}
	
	
	function getBlockNumber() public view returns (uint) {
		return block.number;
	}
	
	function getBlockhash() public view returns (uint) {
		return uint(blockhash(block.number - shift_block));
	}
}