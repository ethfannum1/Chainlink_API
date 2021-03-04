[![](https://github.com/ethfannum1/Chainlink_API/blob/main/chainlink-logo.jpg)](https://github.com/ethfannum1/Chainlink_API/blob/main/chainlink-logo.jpg)

This is a example of how to use Chainlink API oracle calls.

Check the Solidity Smart Contract in folder contracts:
    Clock.sol

This smart contract is deployed in Kovan testnet, and owns some ETH and LINK Token in order to work.

It calls the Chainlink smart contract oracle to get a response from it each x time, where x is a parameter the user can choose.

Once the x time is up, the smart contract variable *alarmDone* is updated to true.

------------

Installation process:

1. Create a initial project:
   ** npm init -y**


2. Init a truffle project:
    **truffle init**


3. Configure file truffle-config.js:


4. Install HDWalletProvider:
   ** npm install truffle-hdwallet-provider**


5. Install ChainlinkClient.sol:
    **nmp i @chainlink/contracts**


6. Compile project:
  **  truffle compile**


7. Deploy Clock.sol contract to Kovan testnet:
   ** truffle migrate --reset --network kovan**


------------

Clock.sol address is already deployed to Kovan testnet at address:
    0x8f4b246C5074d743F401265C3DF90cC0E8059e96




