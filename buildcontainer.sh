#!/bin/bash
set +e
REMOTE=opensourcelan
. common.sh

TS=$(gettimestamp)
docker build -t origin-docker:latest -t origin-docker:$TS -t $REMOTE/origin-docker:latest -t $REMOTE/origin-docker:$TS .

(cd sniproxy && docker build -t sniproxy:latest -t sniproxy:$TS -t $REMOTE/sniproxy:latest -t $REMOTE/sniproxy:$TS . )
(cd dnsmasq && docker build -t dnsmasq:latest -t dnsmasq:$TS -t $REMOTE/dnsmasq:latest -t $REMOTE/dnsmasq:$TS  . )
