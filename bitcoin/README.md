# Bitcoin Tutorial

- You need to have a big bit of disk drive available, around 100GB

- You then create a file in your home dir called `.bitcoin.conf` with the following variables in it

	#!/bin/bash

	export BITCOIN_DATA_DIR=<your dir here>

	export BITCOIN_RPC_USER=<username>
	export BITCOIN_RPC_PASSWORD=<very secure password>

- You don't want anyone to be able to see your username and password, otherwise they can hack your bitcoind!

Then do `./run-bitcoind.sh`

And bitcoin should fire up. You can `tail-bitcoin.sh` to follow what its doing 

- you can now run the tutorials.
