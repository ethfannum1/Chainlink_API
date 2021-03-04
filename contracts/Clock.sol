
// -----------------------------------------------------------------------------------------------------------------
// proceso de llamada y recepción de una transacción externa a la blockchain.

// cada x segundos el oráculo hace una transacción a este contrato, pero sin traer ningún dato (transacción vacía):
// la tarea (job) es hacer una transacción al cabo de un tiempo que le estipulemos.

// transacción interna = mensaje = transacciones entre contratos
// -----------------------------------------------------------------------------------------------------------------


pragma solidity ^0.6.0;

// ----------------------------------------------------------------------------
// ChainlinkClient.sol:
// Este es el contrato que nos va a permitir hacer llamadas request a oráculos.
// ----------------------------------------------------------------------------


// Importación desde ejecución en disco
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

// Importación desde ejecución en Remix
// import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/ChainlinkClient.sol";


contract Clock is ChainlinkClient {

    // Este contrato le dice al oráculo: dentro de x segundos haz una transacción a mi address.
    bool public alarmDone;

    // 3 variables propias del ecosistema Chainlink:
    address private oracle; // Address del oráculo.
    bytes32 private jobId; // El código del tipo de petición/trabajo que se hace al oráculo. https://market.link/search/jobs?network=42
    uint256 private fee; // Lo que hay que pagar, en LINKS, al oráculo por su servicio.

    /*  "Los Adaptadores (en Chainlink) son esas cosas que ejecuta cada tarea." 
        "Hay adaptadores diseñados por Chainlink, pero cada uno puede hacer los suyos." 
    */


    constructor() public {
        /*  "Poner cuál es la address del token que gestiona el link. Ese smart contract que lleva todos los balances de las address con los links de cada una"
            Sets the stored address for the LINK token which is used to send requests to Oracles. There are different token addresses on different network.
            https://docs.chain.link/docs/chainlink-framework#setchainlinktoken 
        */
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);

        // La address del oráculo en la red Kovan.
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;

        // El código del trabajo a ejecutar.
        jobId = "a7ab70d561d34eb49e9b1612fd2e044b";

        // Precio a pagar en LINK.
        fee = 0.1 * 10**18; // 0.1 LINK // Expresarlo en la unidad mínima de LINK.

        alarmDone = false;
    }


    // --------------------------------------------------------------------------------------
    // CONSTRUCCIÓN de una PETICIÓN al oráculo de Chainlink
    // --------------------------------------------------------------------------------------
    function requestAlarmClock(uint256 durationInSeconds) public returns(bytes32 requestId) {
        // Chainlink.Request es un struct

        // Construir una petición a Chainlink.
        Chainlink.Request memory request = buildChainlinkRequest(jobId, // ID del trabajo pedido.
                                                                 address(this), // La address del contrato, a la que el contrato del oráculo mandará la transacción: a nuestro contrato.
                                                                 this.fulfillAlarm.selector); // La función callback de nuestro contrato que recibirá la transacción.
                                                            
        /*  Añadimos más parámetros al objeto request recibido. 
            Se le indica el: "dentro de cuántos segundos"  
            
            addUint
            https://docs.chain.link/docs/chainlink-framework#adduint  

            "until"
            https://docs.chain.link/docs/chainlink-alarm-clock#until
        */
        request.addUint("until", block.timestamp + durationInSeconds); // The timestamp for which the Chainlink node will wait to respond.

        // Enviar al oráculo la petición de transacción.
        return sendChainlinkRequestTo(oracle, request, fee);
    }


    // --------------------------------------------------------------------------------------
    // RECEPCIÓN de la PETICIÓN al oráculo de Chainlink
    // --------------------------------------------------------------------------------------
    /*  Modificador: recordChainlinkFulfillment:
        Used on fulfillment callbacks to ensure that the caller and requestId are valid. This is the modifier equivalent of the method validateChainlinkCallback.
        https://docs.chain.link/docs/chainlink-framework#recordchainlinkfulfillment 
    */
    function fulfillAlarm(bytes32 _requestId) public recordChainlinkFulfillment(_requestId) {
        // Transacción recibida.
        alarmDone = true;
    }


    // --------------------------------------------------------------------------------------
    // RECUPERACION de tokens LINK
    // --------------------------------------------------------------------------------------
    /*  Recuperar los token LINK que se habían depositado en el contrato de Chainlink,
        porque por ejemplo este contrato en un futuro ya no tenga más vigencia. 
    */
    function withdrawLink() external {
        // Instanciar el contrato que gestiona el token link.

        // The chainlinkTokenAddress function is a helper used to return the stored address of the Chainlink token.
        // https://docs.chain.link/docs/chainlink-framework#chainlinktokenaddress
        LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());

        // Transferir fondos:
        // Todo el balance que tenga este contrato "linkToken.balanceOf(address(this)))" en LINKS, envíaselo al que está llamando a esta función.
        require(linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))), "Unable to transfer");
    }


}



