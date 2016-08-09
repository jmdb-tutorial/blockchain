# Eris

[Eris](https://erisindustries.com/) is working on building a toolset on top of other blockchain technologies to make it simpler to work with.

They have some tutorials available [here](https://docs.erisindustries.com/tutorials/contracts-deploying/).

https://docs.erisindustries.com/tutorials/solidity/


# REST API

http://192.168.99.100:1337/blockchain
http://192.168.99.100:1337/blockchain/latest_block
http://192.168.99.100:1337/blockchain/block/7631
http://192.168.99.100:1337/accounts/DFF784DB8C4B164E987F25E44A76E6201F3C4D57
http://192.168.99.100:1337/accounts/DA853491290DCCFB8E6BBFD85B471324381D4B54

http://tendermint.com/blog/tendermint-vs-pbft/

# Day to day running

Start docker machine

docker-machine start default

Source the simple chain environment

source simple-chain-env.sh

Which is in this directory

To see a list of running services, try

eris services ls

To see what chains you have running, try:

eris chains ls

you should see something like this:

$ eris chains ls
CHAIN           ON     CONTAINER ID     DATA CONTAINER
simplechain     *      815aea6ba8       0f399f03d9

If theres no `*` under `ON` then you can start your chain with

eris chains start simplechain

Et Voila!

You can find out the IP address from:
eris chains inspect simplechain NetworkSettings.IPAddress


# Create and execute a transaction

Use this command to run the  epm script - this uses an online compiler so you need internet connection

	cd ~/.eris/apps/idi
	eris pkgs do --chain simplechain --address $addr --machine default

After this you should see something like this:

	Performing action. This can sometimes take a wee while
	Executing Job                                 defaultAddr
	Executing Job                                 setStorageBase
	Executing Job                                 deployStorageK
	Deploying Contract                       name=IdisContractsFTW
	addr=CC64956D4D9E7BE8B508330598A657B4CBA91F05
	Executing Job                                 setStorage
	Executing Job                                 queryStorage
	Return Value                                  5
	Executing Job                                 assertStorage
	Assertion Succeeded                           5 == 5

This is running a set of jobs listed in `epm.yml`

The results of these jobs is output in epm.json. This epm basically compiles and deploys the contract to an address, which is given byt the "deployStorageK" field. the node app uses this value to know where the contract address is.

You now can follow the steps in :

 https://docs.erisindustries.com/tutorials/contracts-interacting/

Basically this also lives in the `~/.eris/apps/idi` directory and is a nodejs app.

Eris uses a javascript api by default so its easiest to build apps using JS for the purposes of demonstrations.

You will need to modify the app.js to point to whatever the IP address of your docker-machine is.

To run the app, do

	node app.js

Its a very simple app and all it does is set the value in storage.

## Notes

https://nodejs.org/en/

Want to install 4.4.7 because thats a good stable version if you look for

	brew search node

you will see that there are various versions available.

Lets try

	brew install node5

	$ node --version
	v5.12.0


I updated the version of eris-contracts in the package.josn to 0.13.3

Also it node was producing a lot of errors about `v8::FunctionTemplate::Set() with non-primitive values is deprecated` So I changed the implementation of the contract to read `setStoredData` and `getStoredData` instead of `get` and `set`.

This is because of the version of node that I had installed. 

I also needed to update the applications epm.yaml to refer to these two methods in the steps the get and set the storage

This didn't make any difference so it must be deeper in the library



# Installation
Installation is as simple as

	brew install eris

Eris needs the latest version of docker (1.11.2) at time of writing and it automatically installs it as a dependency with homebrew.

On my system because I already had docker-machine installed, I needed to re-link the binaries to the new ones that brew had just downloaded...

	brew link --overwrite docker
	brew link --overwrite docker-machine

I also needed to upgrade my existing default docker image:

	docker-machine start default
	docker-machine upgrade default
	eval $(docker-machine env default)
	docker --version
	==> Docker version 1.11.2, build b9f10c9
	
Now your ready to initialise eris:

	eris init

This does quite a bit of hevy lifting, including downloading 1GB of docker images so I left it running overnight.

You first need to set up a chain as per https://docs.erisindustries.com/tutorials/chain-making/

You are now ready to follow the tutorial @ https://docs.erisindustries.com/tutorials/contracts-deploying/

I found that I had not started the compilers service for some reason. It doesn't seem to be in either of the tutorials.

Use this command to run the  epm script
	cd ~/.eris/apps/idi
	eris pkgs do --chain simplechain --address $addr --machine default

After this you should see something like this:

	Performing action. This can sometimes take a wee while
	Executing Job                                 defaultAddr
	Executing Job                                 setStorageBase
	Executing Job                                 deployStorageK
	Deploying Contract                       name=IdisContractsFTW
	addr=CC64956D4D9E7BE8B508330598A657B4CBA91F05
	Executing Job                                 setStorage
	Executing Job                                 queryStorage
	Return Value                                  5
	Executing Job                                 assertStorage
	Assertion Succeeded                           5 == 5

You cshould then be able to run this https://docs.erisindustries.com/tutorials/contracts-interacting/

I updated the version of eris-contracts in the package.josn to 0.13.3

Also it node was producing a lot of errors about `v8::FunctionTemplate::Set() with non-primitive values is deprecated` So I changed the implementation of the contract to read `setStoredData` and `getStoredData` instead of `get` and `set`.

I also needed to update the applications epm.yaml to refer to these two methods in the steps the get and set the storage

This didn't make any difference so it must be deeper in the library
