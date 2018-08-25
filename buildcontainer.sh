#!/bin/bash

. common.sh

TS=$(gettimestamp)
docker build -t origin-docker:latest -t origin-docker:$TS -t opensourcelan/origin-docker:latest -t opensourcelan/origin-docker:$TS .

(cd sniproxy && docker build -t sniproxy . )
(cd dnsmasq && docker build -t dnsmasq . )
