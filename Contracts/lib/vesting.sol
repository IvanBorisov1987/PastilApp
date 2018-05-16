pragma solidity ^0.4.23;

//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title SafeMath
 * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
 */
library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC20 {
    function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
    function balanceOf(address who) external returns(uint256);
}
/**
 * @title Ownable
 * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
 */
contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

// 0x81cfe8efdb6c7b7218ddd5f6bda3aa4cd1554fd2, 1526337955, 43200, 86400, true
contract TokenVesting is Ownable {
    using SafeMath for uint256;
    //using SafeERC20 for ERC20;

    event Released(uint256 amount);
    event Revoked();
    // получатель токена после выпуска
    address public beneficiary; // адрес выгодоприобритателя токена

    uint256 public cliff; // период холда после которого начнеться распространение в unix timestamp
    uint256 public start; // старт
    uint256 public duration; //продолжительность действия

    bool public revocable;

    mapping (address => uint256) public released; // высвобожденные токены на адресе
    mapping (address => bool) public revoked; // анулированные токены

    constructor(
        address _beneficiary, // получатель
        uint256 _start, // дата начала периода
        uint256 _cliff, // период заморозки
        uint256 _duration, // общая продожительность всего цикла(заморозка + время расределения)
        bool _revocable // отзывной ли токен(можно ли анулировать)
    )
    public
    {
        require(_beneficiary != address(0));
        require(_cliff <= _duration);
        beneficiary = _beneficiary;
        revocable = _revocable;
        duration = _duration;
        cliff = _start.add(_cliff);
        start = _start;
    }
    //Отправка vested токенов бенефициару - высвобожденная сумма считается в vestedAmount
    function release(ERC20 token) public {
        uint256 unreleased = releasableAmount(token); // в качестве параметра передается тоткен, который отправляем
        require(unreleased > 0); // проверка что токенов больше 0
        released[token] = released[token].add(unreleased); // добавлеие в мепинг высвобожденных токенов
        token.transfer(beneficiary, unreleased); // безопастный трансфер
        emit Released(unreleased); // событие
    }
    /* Позволяет владельцу СК отозвать наделение. Токены, уже принадлежащие остаются в договоре, остальные возвращаются владельцу СК.*/
    function revoke(ERC20 token) public onlyOwner { // анулирование адреса токена
        require(revocable); // проверка что токен отзывной
        require(!revoked[token]); // проверка что он не блы анулирован ранее
        uint256 balance = token.balanceOf(this);
        uint256 unreleased = releasableAmount(token);
        uint256 refund = balance.sub(unreleased);
        revoked[token] = true;
        token.transfer(owner, refund);
        emit Revoked();
    }
    /* Вычисляет сумму, которая уже присвоена, но еще не выпущена*/
    function releasableAmount(ERC20 token) public returns (uint256) {
        return vestedAmount(token).sub(released[token]);
    }
    /*  Вычисляет сумму, которая уже присвоена. */
    function vestedAmount(ERC20 token) public returns (uint256) {
        uint256 currentBalance = token.balanceOf(this);
        uint256 totalBalance = currentBalance.add(released[token]);

        if (block.timestamp < cliff) {
            return 0;
        } else if (block.timestamp >= start.add(duration) || revoked[token]) {
            return totalBalance;
        } else {
            return totalBalance.mul(block.timestamp.sub(start)).div(duration);
        }
    }
}