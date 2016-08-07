#!/bin/bash

source ~/.bitcoind.conf

tail -f ${BITCOIN_DATA_DIR}/debug.log
