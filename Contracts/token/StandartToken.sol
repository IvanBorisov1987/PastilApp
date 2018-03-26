pragma solidity ^0.4.18;


import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
//import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";




contract SimpleToken is Ownable, BurnableToken, StandardToken {

    using SafeMath for uint;

    string public name;
    string public symbol;
    uint256 public constant decimals = 18;
    uint256 dec = 10**decimals;

    address public owner;
    uint256 public totalSupply;
    uint256 public avaliableSupply;
    uint256 public buyPrice = 800000000000000; // тут может быть любая

    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    function SimpleToken(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public
    {
        totalSupply = initialSupply*1e18;
        balanceOf[this] = totalSupply;
        avaliableSupply = balanceOf[this];
        name = tokenName;
        symbol = tokenSymbol;
        owner = msg.sender;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transferFrom(address _from, address _to, uint256 _value) public  returns(bool) {
        require(_from != address(0x0));
        require(_to != address(0x0));
        return super.transferFrom(_from, _to, _value);
    }



    function burnFrom(address _from, uint256 _value) public {
        require(_value <= balances[msg.sender]);
        require(_from != address(0x0));

        balances[_from] = balances[_from].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);
        emit Burn(_from, _value);
        emit Transfer(_from, address(0), _value);
    }
}
//