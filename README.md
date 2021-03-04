[![](https://github.com/ethfannum1/Chainlink_API/blob/main/chainlink-logo.jpg)](https://github.com/ethfannum1/Chainlink_API/blob/main/chainlink-logo.jpg)

This is a example of how to use Chainlink API oracle calls.

Check the Solidity Smart Contract in folder contracts:
    Clock.sol

This smart contract is deployed in Kovan testnet, and owns some ETH and LINK Token in order to work.

It calls the Chainlink smart contract oracle to get a response from it each x time, where x is a parameter the user can choose.

Once the x time is up, the smart contract variable *alarmDone* is updated to true.

------------