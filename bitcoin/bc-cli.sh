#!/bin/bash

source ~/.bitcoind.conf

bitcoin-cli -datadir=${BITCOIN_DATA_DIR} $@
