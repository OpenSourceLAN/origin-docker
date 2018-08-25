#!/bin/bash

. ../common.sh

TS=$(gettimestamp)

docker build -t sniproxy:latest -t sniproxy:$TS -t opensourcelan/sniproxy:latest -t opensourcelan/sniproxy:$TS .
