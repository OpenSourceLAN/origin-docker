#!/bin/bash

get_ip() {
  interface=$(ip route | grep default | awk '{print $(NF)}')
  ip addr show dev $interface | grep 'inet ' | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' | head -n 1

}

[[ -z $HOST_IP ]] && export HOST_IP=$(get_ip) &&  echo "\$HOST_IP not set - using $HOST_IP"
[[ -n $HOST_IP ]] || (echo "\$HOST_IP not set and couldn't detect it. Bailing hard." && exit 1)

docker rm -f cache_dnsmasq
docker run -it -d -e "HOST_IP=$HOST_IP" -p 53:53 -p 53:53/udp --name cache_dnsmasq dnsmasq
