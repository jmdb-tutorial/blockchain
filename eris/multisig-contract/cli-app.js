// requires
var fs = require ('fs');
var prompt = require('prompt');
var erisC = require('eris-contracts');

// NOTE. On Windows/OSX do not use localhost. find the
// url of your chain with:
// docker-machine ls
// and find the docker machine name you are using (usually default or eris).
// for example, if the URL returned by docker-machine is tcp://192.168.99.100:2376
// then your erisdbURL should be http://192.168.99.100:1337/rpc
var erisdbURL = "http://192.168.99.100:1337/rpc";

// get the abi and deployed data squared away
var contractData = require('./epm.json');
var loanContractAddress = contractData["deployLoanK"];
var loanAbi = JSON.parse(fs.readFileSync("./abi/" + loanContractAddress));

// properly instantiate the contract objects manager using the erisdb URL
// and the account data (which is a temporary hack)
var accountData = require('./accounts.json');
var contractsManager = erisC.newContractManagerDev(erisdbURL, accountData.multisig_full_000);

// properly instantiate the contract objects using the abi and address
var loanContract = contractsManager.newContractFactory(loanAbi).at(loanContractAddress);

// display the current status of the contract
function getStatus() {
  loanContract.getStatus(function(error, result){
    if (error) { throw error }
    console.log("Loan Status Is:\t\t\t" + result);    
  });
}

// 

// run
getStatus();
console.log("Finished.");

