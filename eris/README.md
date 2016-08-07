# Eris

[Eris](https://erisindustries.com/) is working on building a toolset on top of other blockchain technologies to make it simpler to work with.

They have some tutorials available [here](https://docs.erisindustries.com/tutorials/contracts-deploying/).

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
