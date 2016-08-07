#!/bin/bash

#https://en.bitcoin.it/wiki/Running_Bitcoin#Sample_Bitcoin.conf
#https://en.bitcoin.it/wiki/Running_Bitcoin

source ~/.bitcoind.conf

echo "Setting rpc user and password to be ${BITCOIN_RPC_USER} and ${BITCOIN_RPC_PASSWORD}."

# Sets up to run rpc but only from localhost.

bitcoind -datadir=${BITCOIN_DATA_DIR} -rpcauth=${BITCOIN_RPC_AUTH} -rpcallowip=127.0.0.1 -server=1 -daemon
