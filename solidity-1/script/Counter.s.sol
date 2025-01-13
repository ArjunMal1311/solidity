// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
// import {Counter} from "../src/Counter.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

// script to deploy the counter contract
// so there's transaction to send to RPC and we sign it using our private key
// nonce is the number of transactions that have been sent from this address
// so we need to increment the nonce for each transaction

// Foundry has another tool called cast
// cast send "address" "store(uint 256) --> The signature" 123 (arguments [123])
// cast send 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 "store(uint256)" 123 --rpc-url $RPC_URL --private-key $PRIVATE_KEY

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast(); // everything after this line should actually send to RPC
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();
        return simpleStorage;
    }
}

// contract CounterScript is Script {
//     Counter public counter;

//     function setUp() public {}

//     function run() public {
//         vm.startBroadcast();

//         counter = new Counter();

//         vm.stopBroadcast();
//     }
// }




// forge script script/Counter.s.sol     [Command to run the script]


// [⠊] Compiling...
// [⠔] Compiling 1 files with Solc 0.8.28
// [⠒] Solc 0.8.28 finished in 429.92ms
// Compiler run successful!
// Script ran successfully.
// Gas used: 324219

// == Return ==
// 0: contract SimpleStorage 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496

// If you wish to simulate on-chain transactions pass a RPC URL.

// so what exactly is happening here?
// there is no rpc url so it spun up temporary anvil blockchain and then tore it down in the end



// ---------------------------------------

// atg@atg:~/Pictures/solidity$ forge script script/Counter.s.sol --rpc-url http://127.0.0.1:8545
// [⠊] Compiling...
// No files changed, compilation skipped
// Script ran successfully.

// == Return ==
// 0: contract SimpleStorage 0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519

// ## Setting up 1 EVM.

// ==========================

// Chain 31337
// Estimated gas price: 2.000000001 gwei
// Estimated total gas used for script: 444514
// Estimated amount required: 0.000889028000444514 ETH

// ==========================

// SIMULATION COMPLETE. To broadcast these transactions, add --broadcast and wallet configuration(s) to the previous command. See forge script --help for more.
// Transactions saved to: /home/atg/Pictures/solidity/broadcast/Counter.s.sol/31337/dry-run/run-latest.json
// Sensitive values saved to: /home/atg/Pictures/solidity/cache/Counter.s.sol/31337/dry-run/run-latest.json


// ---------------------------------------

// atg@atg:~/Pictures/solidity$ forge script script/Counter.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
// [⠊] Compiling...
// No files changed, compilation skipped
// Script ran successfully.

// == Return ==
// 0: contract SimpleStorage 0x5FbDB2315678afecb367f032d93F642f64180aa3

// ## Setting up 1 EVM.

// ==========================

// Chain 31337

// Estimated gas price: 2.000000001 gwei

// Estimated total gas used for script: 444514

// Estimated amount required: 0.000889028000444514 ETH

// ==========================

// ##### anvil-hardhat
// ✅  [Success] Hash: 0x13cb5c3972def74ac6d99b83d905e8432dcc67e4f531d8727d266d73bb2f9260
// Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
// Block: 1
// Paid: 0.000341934000341934 ETH (341934 gas * 1.000000001 gwei)
// ✅ Sequence #1 on anvil-hardhat | Total Paid: 0.000341934000341934 ETH (341934 gas * avg 1.000000001 gwei)
                                                                                                                   

// ==========================

// ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
// Transactions saved to: /home/atg/Pictures/solidity/broadcast/Counter.s.sol/31337/run-latest.json
// Sensitive values saved to: /home/atg/Pictures/solidity/cache/Counter.s.sol/31337/run-latest.json



// ------------------------------------------------------------------------------------------------

//   "transactions": [
//     {
//       "hash": "0x13cb5c3972def74ac6d99b83d905e8432dcc67e4f531d8727d266d73bb2f9260",
//       "transactionType": "CREATE",
//       "contractName": "SimpleStorage",
//       "contractAddress": "0x5fbdb2315678afecb367f032d93f642f64180aa3",
//       "function": null,
//       "arguments": null,
//       "transaction": {
//         "from": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
//         "gas": "0x6c862",
//         "value": "0x0",
//         "input": "0x6080604052348015600e575f5ffd5b506105378061001c5f395ff3fe608060405234801561000f575f5ffd5b5060043610610055575f3560e01c80632e64cec1146100595780636057361d1461006f5780636f760f41146100835780638bab8dd5146100965780639e7a13ad146100c1575b5f5ffd5b5f545b6040519081526020015b60405180910390f35b61008161007d36600461023e565b5f55565b005b6100816100913660046102f4565b6100e2565b61005c6100a4366004610336565b805160208183018101805160028252928201919093012091525481565b6100d46100cf36600461023e565b61018a565b604051610066929190610370565b60408051808201909152818152602081018381526001805480820182555f91909152825160029091027fb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf68101918255915190917fb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf701906101629082610430565b5050508060028360405161017691906104eb565b908152604051908190036020019020555050565b60018181548110610199575f80fd5b5f91825260209091206002909102018054600182018054919350906101bd906103ac565b80601f01602080910402602001604051908101604052809291908181526020018280546101e9906103ac565b80156102345780601f1061020b57610100808354040283529160200191610234565b820191905f5260205f20905b81548152906001019060200180831161021757829003601f168201915b5050505050905082565b5f6020828403121561024e575f5ffd5b5035919050565b634e487b7160e01b5f52604160045260245ffd5b5f82601f830112610278575f5ffd5b813567ffffffffffffffff81111561029257610292610255565b604051601f8201601f19908116603f0116810167ffffffffffffffff811182821017156102c1576102c1610255565b6040528181528382016020018510156102d8575f5ffd5b816020850160208301375f918101602001919091529392505050565b5f5f60408385031215610305575f5ffd5b823567ffffffffffffffff81111561031b575f5ffd5b61032785828601610269565b95602094909401359450505050565b5f60208284031215610346575f5ffd5b813567ffffffffffffffff81111561035c575f5ffd5b61036884828501610269565b949350505050565b828152604060208201525f82518060408401528060208501606085015e5f606082850101526060601f19601f8301168401019150509392505050565b600181811c908216806103c057607f821691505b6020821081036103de57634e487b7160e01b5f52602260045260245ffd5b50919050565b601f82111561042b57805f5260205f20601f840160051c810160208510156104095750805b601f840160051c820191505b81811015610428575f8155600101610415565b50505b505050565b815167ffffffffffffffff81111561044a5761044a610255565b61045e8161045884546103ac565b846103e4565b6020601f821160018114610490575f83156104795750848201515b5f19600385901b1c1916600184901b178455610428565b5f84815260208120601f198516915b828110156104bf578785015182556020948501946001909201910161049f565b50848210156104dc57868401515f19600387901b60f8161c191681555b50505050600190811b01905550565b5f82518060208501845e5f92019182525091905056fea26469706673582212206956b441c0a47dbeff76df887520be73c39020327f9e2eed97dfb8d153bb87ca64736f6c634300081c0033",
//         "nonce": "0x0",
//         "chainId": "0x7a69"
//       },
//       "additionalContracts": [],
//       "isFixedGasLimit": false
//     }

// all these are stored in the broadcast folder
// run-latest.json is the latest transaction

//gas and all are in hex

// nonce is the number of transactions that have been sent from this address
// chainId is the chain id of the blockchain

// input is the bytecode of the contract


// r, s, v are the signature of the transaction
// private signatures 

// every single wallet has a counter of how many transactions have been sent from it
// which is basically the nonce

