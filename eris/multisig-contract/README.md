# Creating a multisig contract in eris

The aim of this application is to build a contract in which one account creates a contract, which then requires signatures from a list of other accounts which the creator will pass in the constructor.

This could represent a scenario of a loan company for example which is making a joint loan offer to two people.

The accounts needed are as follows:

| ACCOUNT_ID    | METHODS CALLED  | DESCRIPTION                                                                                         |
| ------------- | --------------- | --------------------------------------------------------------------------------------------------- |
| EXECUTOR      | create          | The entity responsible for controlling the transaction. Could be the bank, or maybe a third party   |
| LENDER        | sign            | The entity giving out the cash, probably a bank                                                     |
| BORROWER_A    | sign            | The first entity who is receiving the cash as a joint loan                                          |
| BORROWER_B    | sign            | The second entity receiving the cash                                                                |
| COUNTER_FRAUD | sign            | The entity responsible for checking that everyone is behaving legitimately                          |
| ALL           | status          | Anyone can see wether the contract is 'effective' or not                                            |

In this example, the contract is "effective" once everyone has signed it. The interesting thing about this contract is that it allows for a very distributed setup. All the systems might be inside a single corporate entity, e.g. the bank, or they could be in completely separate organisations. 

# Installation

First you need to install docker and docker-machine (https://docs.erisindustries.com/tutorials/tool-specific/docker_machine/)

https://docs.erisindustries.com/explainers/the-eris-stack/

Then create a machine for eris:

	docker-machine create eris --driver virtualbox

	docker-machine env eris

eval the docker machine env.

Check it

	docker-machine ls

	NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
	default   -        virtualbox   Stopped                                       Unknown   
	eris      *        virtualbox   Running   tcp://192.168.99.100:2376           v1.12.1   

The * under ACTIVE means that you are connected to that one. Its very important to call your docker machine `eris` - in theory eris respects whatever the active docker box is but its just simpler to do this to prevent any wierdness.

Now run `eris init`

This will download all the eris images into your docker machine. This takes some time, theres about 1GB of them.

Theres a core service called `kets which you need to have running to manage various crypto keys. 

	eris services start keys

We now need to generate a key:

	eris keys gen

	eris keys ls
	No keys found on host
	The keys in your container kind marmot        <KEY>

So we can back up the key, we want to export it to our host.

	eris keys export <KEY>

If you want to clear out all the keys

	eris services stop keys
	eris services rm -x keys
	eris services start keys


The first thing we are going to do is set up a new chain with the right number of accounts in it. If you need to remove the chain first:

	eris chains stop multisig
	eris chains rm multisig --data --dir --file --force 


It looks like the chains marmot has a different `eris/base` image configured. If you look in `docker images` you will see something like this:

	REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
	quay.io/eris/data      latest              139360deb878        26 hours ago        205.4 MB
	quay.io/eris/data      <none>              139360deb878        26 hours ago        205.4 MB
	quay.io/eris/keys      latest              f9f886412dfb        3 weeks ago         374.8 MB
	quay.io/eris/keys      <none>              f9f886412dfb        3 weeks ago         374.8 MB
	quay.io/eris/erisdb    0.11.4              06365aeae441        10 weeks ago        607.2 MB
	quay.io/eris/erisdb    <none>              06365aeae441        10 weeks ago        607.2 MB
	quay.io/eris/ipfs      latest              a660d3b2494f        11 weeks ago        353.9 MB
	quay.io/eris/ipfs      <none>              a660d3b2494f        11 weeks ago        353.9 MB
	quay.io/eris/epm       0.11.4              7505721901fa        3 months ago        764.4 MB
	quay.io/eris/epm       <none>              7505721901fa        3 months ago        764.4 MB
	quay.io/eris/eris-cm   0.11.4              8f48858f312a        3 months ago        780 MB
	quay.io/eris/eris-cm   <none>              8f48858f312a        3 months ago        780 MB
	eris/base              latest              a82b6eb25f46        10 months ago       564.7 MB
	eris/base              <none>              a82b6eb25f46        10 months ago       564.7 MB

But when you run `chains` it looks for `quay.io/eris/base` which isn't there yet and needs downloading. Once its done its all good.

https://docs.erisindustries.com/tutorials/advanced/chain-making/

You are now going to create a chain with the appropriate accounts.

	eris chains make --account-types=Root:1,Full:1,Participant:4 multisig

https://github.com/eris-ltd/eris-contracts.js/issues/28

This is going to create a chain called `multisig` with 5 full access accounts and 2 root accounts. Its basically setting up meta data for the chain, including the genesis.json file. It creates a subfolder for each account which has a `genesis.json` file in it which will be passed later to chains new to instantiate the chain.

For some reason this doesn't seem to be being copied into the chain though.

You can now run the script `source ./multisig-env.sh` in this folder which will set up some useful environment variables for you.

There will be 5 accounts, called :

	multisig_root_000, multisig_full_000, multisig_participant_000, multisig_participant_001, multisig_participant_002, multisig_participant_003

We will map these to the accounts above like this:

| multisig_full_000 | EXECUTOR      |
| multisig_participant_000 | LENDER        |
| multisig_participant_001 | BORROWER_A    |
| multisig_participant_002 | BORROWER_B    |
| multisig_participant_003 | COUNTER_FRAUD |

Next up we need to instantiate our chain. If you have your simplechain running, stop it first. If you want to clean everything up do
	eris chains rm multisig --data --dir --file --force 

If you just want to remove the chain and not the metadata

	eris chains rm -x multisig
then

	eris chains new multisig --dir $chain_dir_this



The $chain_dir_this is important - it is the node config directory that we have created. Because we only created one full account type we only have a single node which of course kind of defeats the object of blockchain but is very useful for testing.

To check the genesis block:

	eris chains cat multisig genesis

You should see a lot of accounts in there with their public keys
You can check its running by doing

	eris chains ls

Or look at its log files:

	eris chains logs multisig -f

You should be able to watch it happily producing blocks at a rate of 1 every three seconds or so depending on your machine. Incidentally the block heigh is given in the source code as being an `int` which on a 64 bit architecture (like a macbook) should give a maximum number of blocks as :

	9223372036854775807 or 9.22E18 (10^18)
                                            
Which means it could last for approximately 97,490,402,892 years (if my maths is correct). To put that in perspective the universe is about 13.79 x 10^9 or 13 billion years, and this is 9.7 x 10^10 so thats about 150 times the life of the universe so far. Big enough?

Also incidentally, eris is using tendermint underneath which has its consensus protocol defined here: http://tendermint.com/docs/tendermint.pdf

https://golang.org/ref/spec#Numeric_types
https://github.com/tendermint/tendermint/blob/master/rpc/core/blocks.go#L34

Ok, now we have a chain running its time to get that contract setup.

If you need to go away or shut your machine down or whatever, you can type:

	eris chains stop multisig

and

	eris chains start multisig

To get it up and running again.

Before doing this, source the env script again which will set up some useful defaults.

	source multisig-env.sh

What we are really interested in is getting an address we can use to deploy our contracts. In this case it is the "Full" account that we created earlier. We can get these from the file `~/.eris/chains/multisig/addresses.csv` the env script also copies this file into the app dir for use later when we interact with the contract via javascript.

If you do

	cat ~/.eris/chains/multisig/addresses.csv

You should see something like this:

	479E013292C44248DA2D257C9052EB800D4D09E2,multisig_full_000
	C8561C44A527AFF4DB24AC7F977D1A590E7951A3,multisig_participant_000
	7959542D88FA0FE95A62B6701E0F276DC137D990,multisig_participant_001
	478D68A4159C76AECBC38B0D901C014FDB12B676,multisig_participant_002
	6EAD9DA629368A1847C40F451E8B5C1D31E0E569,multisig_participant_003
	2D680589FC9895C0A482C2BB4A6D27585AE110DB,multisig_root_000

In the env script, we just extract the address associated with multisig_full_000 and stick it in a variable called `$addr` (thanks to the marmots from the documentation for this.

	echo $addr

Sweet, the marmots are ready!

The file we want is called `loan.sol` in this directory. You can see if it is valid solitidy, [here](https://ethereum.github.io/browser-solidity/#version=0.3.6).

Now that we have a valid contract, we need to deploy it.

To do this we use the eris package manager, which takes an input yml file and does things for us. Its a bit like an ansible script.

We already have am `epm.yaml` file which simply has a job to deploy the contract and wait for it to be deployed.

We first need to get the address of an account to use to deploy the contract. We are going to use the "executor" address. This lives in an addresses.csv file in the multisig chain dir.

	addr=$(cat $chain_dir/addresses.csv | grep multisig_full_000 | cut -d ',' -f 1)

This is already done if you sourced the multisig-env.sh

Lets check that our chain is running

	eris chains ls 

You should see a `*` next to the `multisig` chain.

By default, eris will try to use its online contract compiler but it sometimes doesn't work so the best thing is to download the compilers image.

See 'Working with a local compiler' at https://docs.erisindustries.com/tutorials/advanced/contracts-deploying/ (compiler_addr also in multsig_env, you will need to source it again after its started) You also need to change the compilers services config to use the right image, like `compilers:0.11.4` instead of `compilers`

	eris services start compilers

	source multisig_env.sh

	compiler_addr=$(eris services inspect compilers NetworkSettings.IPAddress)

Then can try this (`${docker_ip}` should be coming from the multisig env

	eris pkgs do --chain multisig --address $addr --compiler ${compiler_addr}:9099

You should see something like this:

	Executing Job                                 defaultAddr
	Executing Job                                 deployLoanK
	Deploying Contract                       name=LoanContract
    addr=DBF32C19F887D998786C7A931139444290E69588
	Executing Job                                 queryStatus
	Return Value                                  0
	Executing Job                                 assertStorage
	Assertion Succeeded                           0 == 0

If there are no errors and you can see "Assertion Succeeded", your chain should be deployed!

This is basically deploying the contract and making a call to it. The call is like a getter to get the "Status" which should be "Created" this is an enum in the `loan.sol` and gets converted to an integer. `0` is the first element in the enum.

We are now going to interact with the contract. We can do this using a javascript api that the marmots kindly provide. To run it we can use node.js so if you don't already have it installed you want to do that now. Its important that you have the right version of node which is `v5` Later versions introduce some deprecation warnings which can be removed but are quite noisy.

We are going to run a node app which is in the multisig dir called `cli-app.js`. To make it run as a node app we need to provide a `package.json` file.

https://docs.erisindustries.com/tutorials/contracts-interacting/

The first thing we do is `npm install` which sets up our node environment for us. It has basically the dependency to the eris client libraries and a library called `prompt` which is used to interact with the command line.

Massively important is to update the ip address of the docker machine in the script!


To get the ip do

	docker-machine ip default

It might be a good idea to tail the logs while you do this...

	eirs chains logs -f multisig

	eris pkgs do --chain multisig --address $addr


# References

http://www.shakelaw.com/blog/when-does-a-contract-take-effect/


