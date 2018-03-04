pragma solidity ^0.4.19;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract Whitelist is Ownable {
    using SafeMath for uint256;

    mapping(address=>bool) public whitelist;

    event Authorized(address wlCandidate, uint timestamp);
    event Revoked(address wlCandidate, uint timestamp);

    function authorize(address wlCandidate) public onlyOwner {
        whitelist[wlCandidate] = true;
        Authorized(wlCandidate, now);
    }

    // also if not in the list..
    function revoke(address wlCandidate) public onlyOwner {
        whitelist[wlCandidate] = false;
        Revoked(wlCandidate, now);
    }

    function authorizeMany(address[50] wlCandidate) public onlyOwner {
        for(uint i = 0; i < wlCandidate.length; i++) {
            authorize(wlCandidate[i]);
        }
    }

    function isWhitelisted(address wlCandidate) public view returns(bool) {
        return whitelist[wlCandidate];
    }
}