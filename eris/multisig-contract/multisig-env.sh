#!/bin/bash

export chain_dir=~/.eris/chains/multisig
export chain_dir_this=$chain_dir/multisig_full_000

export addr=$(cat $chain_dir/addresses.csv | grep multisig_full_000 | cut -d ',' -f 1)
export docker_ip=$(docker-machine ip eris)
export compiler_addr=$(eris services inspect compilers NetworkSettings.IPAddress)

cp ~/.eris/chains/multisig/accounts.json .

