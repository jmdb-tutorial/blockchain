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
//var loanAbi = JSON.parse(fs.readFileSync("./abi/" + loanContractAddress));
var loanAbi = JSON.parse(fs.readFileSync("./abi/LoanContract"));

//console.log(JSON.stringify(loanAbi, undefined, 2));

// properly instantiate the contract objects manager using the erisdb URL
// and the account data (which is a temporary hack)
var accountData = require('./accounts.json');

var executor = accountData.multisig_full_000;
var lender = accountData.multisig_participant_000;
var borrowerA = accountData.multisig_participant_001;
var borrowerB = accountData.multisig_participant_002;
var counterFraud = accountData.multisig_participant_003;

var contractsManager = erisC.newContractManagerDev(erisdbURL, executor);

// properly instantiate the contract objects using the abi If you want to access one you've already created you add at(loanContractAddress); to the back
var loanContract;

var contractFactory = contractsManager.newContractFactory(loanAbi);

//var loanContract = contractsManager.newContractFactory(loanAbi).at("F88CE097914989AC99354C3420BF926A7256A943");

function createContract(callback) {
    contractFactory.new("hashofcontract", [borrowerA, borrowerB], lender, counterFraud, function(error, contract){
        if(error) {throw error}
        loanContract = contract;
        console.log("Created contract : " + loanContract.address);
        callback();
    });
}

// display the current status of the contract
function getStatus() {
    console.log("Trying to get the status from contract at " + loanContract.address);
    loanContract.getStatus(function(error, result){
        if (error) { throw error }
        console.log("Loan Status Is:\t\t\t" + result);    
    });
}

function getHashOfContract() {
    console.log("Trying to get the hashofthecontract at " + loanContract.address);
    loanContract.getStatus(function(error, result){
        if (error) { throw error }
        console.log("HashOfContract Is:\t\t\t" + result);    
    });
}


// 

// run
createContract(getHashOfContract);

//getStatus();

//getHashOfContract();
