pragma solidity ^0.4.21;
/**
* Контракт запрашивает цену ETH к USD каждые 60 секунд
*/
import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract oracul is usingOraclize {

    uint256 public usdToEther;
    uint256 public etherBuyPrice;
    uint256 public tokenNominal;

    event newPriceTicker(uint price);
    event AuthorizedReferer(address _referer, uint256 _time);

    function __callback(bytes32 myid, string result) public {
        if (msg.sender != oraclize_cbAddress()) throw;
        usdToEther = parseInt(result, 0);
        updatePriceUsdToEther();
        etherBuyPrice = tokenNominal/usdToEther;
        emit newPriceTicker(usdToEther);
    }

    function updatePriceUsdToEther() payable {
        if (oraclize_getPrice("URL") > this.balance ){
            emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
            return;
        } else {
            emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
            oraclize_query(60, "URL", "json(https://min-api.cryptocompare.com/data/pricehistorical?fsym=ETH&tsyms=USD ).ETH.USD");
        }
}