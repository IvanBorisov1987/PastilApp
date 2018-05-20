// 0xC032D3fCA001b73e8cC3be0B75772329395caA49, 1526461102, 600, 1200, true
pragma solidity ^0.4.23;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract TokenVesting is Ownable {

    using SafeMath for uint256;
    using SafeERC20 for ERC20Basic;

    event Released(uint256 amount);
    event Revoked();

    address public beneficiary;
    uint256 public cliff;
    uint256 public start;
    uint256 public duration;
    uint256 public tokensAmount;

    bool public revocable;

    mapping (address => uint256) public released;
    mapping (address => bool) public revoked;

    constructor(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        bool _revocable,
        uint256 _tokensAmount
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
        tokensAmount = _tokensAmount;
    }

    /* @notice отправка vested tokens бенефициару*/
    function release(ERC20Basic token) public {
        uint256 unreleased = releasableAmount(token);
        require(unreleased > 0);
        released[token] = released[token].add(unreleased);
        token.safeTransfer(beneficiary, unreleased);
        emit Released(unreleased);
    }

    function revoke(ERC20Basic token) public onlyOwner {
        require(revocable);
        require(!revoked[token]);
        uint256 balance = token.balanceOf(this);
        uint256 unreleased = releasableAmount(token);
        uint256 refund = balance.sub(unreleased);
        revoked[token] = true;
        token.safeTransfer(owner, refund);
        emit Revoked();
    }
    /* @dev Вычисляет сумму, которая уже vested но еще не высобожден.*/
    function releasableAmount(ERC20Basic token) public view returns (uint256) {
        return vestedAmount(token).sub(released[token]);
    }

    /* @dev Вычисляет сумму, которая уже vested.*/
    function vestedAmount(ERC20Basic token) public view returns (uint256) {
        uint256 currentBalance = token.balanceOf(this); // общий баланс токенов на данном счете
        uint256 totalBalance = currentBalance.add(released[token]); //общий баланс +

        if (block.timestamp < cliff) {
            return 0; // ничего если еще не прошел холд
        } else if (block.timestamp >= start.add(duration) || revoked[token]) {
            return totalBalance; //возврат всех средств если дюрация прошла
        } else {
            return totalBalance.mul(block.timestamp.sub(start)).div(duration); // возврт пропорции = общий баланс*(now - star) / продолжительность
        }
    }
}