#!/bin/bash

source ~/.bitcoind.conf

echo "Setting rpc user and password to be ${BITCOIN_RPC_USER} and ${BITCOIN_RPC_PASSWORD}."

bitcoind -datadir=${BITCOIN_DATA_DIR} -daemon
