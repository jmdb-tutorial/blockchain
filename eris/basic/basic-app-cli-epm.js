// requires
var fs = require ('fs');
var prompt = require('prompt');
var erisC = require('eris-contracts');

var debug = false;

// Need to set this to be whatever your eris docker host is (docker-machine ip eris)
var erisdbURL = "http://192.168.99.100:1337/rpc";

// Load the abi (definition file) which will have been created by the compiler
var contractData = require('./epm.json');
var contractAddress = contractData["deployBasicK"];
//var contractAbi = JSON.parse(fs.readFileSync("./abi/" + contractAddress));
var contractAbi = JSON.parse(fs.readFileSync("./abi/BasicContract"));

if (debug) {
    console.log(JSON.stringify(contractAbi, undefined, 2));
}

// Laod up account data (you need to copy this from your chain dir)
var accountData = require('./accounts.json');

var executor = accountData.multisig_full_000;
var contractsManager = erisC.newContractManagerDev(erisdbURL, executor);
var contractFactory = contractsManager.newContractFactory(contractAbi);

var contract = contractsManager.newContractFactory(contractAbi).at(contractAddress);

var stateIntA_init = 666;
var stateIntB_init = 999;
var stateString_init = "bar";

function initialise() {
    contract.initialise(stateIntA_init, stateIntB_init, stateString_init,
		function(error, result) {
		    if (error) {throw error}
		    getStateIntA();
		});
}

function getStateIntA() {
    contract.getStateIntA(function(error, result) {
        if (error) { throw error }
        console.log("StateIntA Is:\t\t\t" + result);    
    });
}


// run
getStateIntA();
initialise();
