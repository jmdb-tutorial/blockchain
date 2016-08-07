#!/bin/bash

source ~/.bitcoind.conf

ls -lhart ${BITCOIN_DATA_DIR}/blocks
du -sh ${BITCOIN_DATA_DIR}/blocks
