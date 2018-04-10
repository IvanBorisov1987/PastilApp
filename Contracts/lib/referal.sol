pragma solidity ^0.4.0;

import "https://github.com/PillarDevelopment/PillarLab/Contracts/token/MintableToken.sol";

contract referal {

    address public owner;
    address[] public refererArray;

    mapping(address=>bool) public refererlist;

    uint256 public quantityMembers; // количество авторизованных адресов

    event AuthorizedReferer(address _referer, uint256 _time);

    function referal(){
    }

    // авторизация в массиве участников программы
    function inRefererList(address referer) internal{
        require(!isRefererlisted(referer));
        refererlist[referer] = true;
        refererArray.push(referer);
        emit AuthorizedReferer(referer, now);
    }

    // функция массовой отправки реферерам токенов
    function transferRefererList() public onlyOwner{
        //require(now > endIcoDate);
        // _transfer(referal, refererArray, );
    }

    // Функция проверки наличия адреса в массиве рефереров
    function isRefererlisted(address referer) public view returns(bool) {
        return refererlist[referer];
    }

    // функция преобразования msg.data в address
    function bytesToAddress(bytes source) internal pure returns(address) {
        uint result;
        uint mul = 1;
        for(uint i = 20; i > 0; i--) {
            result += uint8(source[i-1])*mul;
            mul = mul*256;
        }
        return address(result);
    }

    function mint (address _to, uint256 _amount) onlyOwner public {
        _amount = _amount*1e18;
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        totalSupply = totalSupply_; // явная инициализация
        balanceOf[_to] = balances[_to]; // явная инициализация
    }


    // Функция, где _inTheList - количество получателей, _amount - количество отправляемых токенов
    function specTransfer(uint64 _firstMember, uint64 _lastMember, uint256 _amount) public onlyOwner {
        require(_lastMember <= quantityMembers);    // проверка что в массиве есть столько членов
        for (uint64 i = _firstMember-1; i<= _lastMember - 1; i++) {     // итерация цикла,
            address tempMembers = refererArray[i];   // временная переменная в цикле для хранения авторизованного адреса
            mint(tempMembers, _amount);     // вызов минта
        }
    }

}
