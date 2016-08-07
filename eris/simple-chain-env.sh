#!/bin/bash

export chain_dir=$HOME/.eris/chains/simplechain
export chain_dir_this=$chain_dir/simplechain_full_000

eval $(docker-machine env default)

export addr=$(cat $chain_dir/addresses.csv | grep simplechain_full_000 | cut -d ',' -f 1)
