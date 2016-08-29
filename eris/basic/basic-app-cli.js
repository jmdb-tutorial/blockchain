// requires
var fs = require ('fs');
var prompt = require('prompt');
var erisC = require('eris-contracts');

var debug = false;

// Need to set this to be whatever your eris docker host is (docker-machine ip eris)
var erisdbURL = "http://192.168.99.100:1337/rpc";

// Load the abi (definition file) which will have been created by the compiler
var contractAbi = JSON.parse(fs.readFileSync("./abi/BasicContract"));

if (debug) {
    console.log(JSON.stringify(contractAbi, undefined, 2));
}

// Laod up account data (you need to copy this from your chain dir)
var accountData = require('./accounts.json');

var executor = accountData.multisig_full_000;

var contractsManager = erisC.newContractManagerDev(erisdbURL, executor);

// properly instantiate the contract objects using the abi If you want to access one you've already created you add .at(loanContractAddress); to the back

var stateIntA_init = 42;
var stateIntB_init = 3;
var stateString_init = "foo";

var contractFactory = contractsManager.newContractFactory(contractAbi);

var contract;

/*
Creates a contract and then invokes a callback when its finished.
*/
function createContract(callback) {
    contractFactory.new(function(error, _contract){
		    if(error) {throw error}
		    contract = _contract;
		    console.log("Created contract @ " + contract.address);
		    callback();
		});
}

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
createContract(function() {console.log("finished"); });
