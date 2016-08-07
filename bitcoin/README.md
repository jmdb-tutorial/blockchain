# Bitcoin Tutorial

- You need to have a big bit of disk drive available, around 100GB

- You then create a file in your home dir called `.bitcoin.conf` with the following variables in it

	#!/bin/bash

	export BITCOIN_DATA_DIR=<your dir here>

	export BITCOIN_RPC_AUTH=<username>:<salt>$<hash>

- You don't want anyone to be able to see your username and password, otherwise they can hack your bitcoind!

- You can generate the rpc_auth string by running `./bitcoin-auth.py <username> <password>` it will randomly pick a salt.

Then do `./run-bitcoind.sh`

And bitcoin should fire up. You can `tail-bitcoin.sh` to follow what its doing 

- you can now run the tutorials.
