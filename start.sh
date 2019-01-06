#!/bin/bash

IMAGE=origin-docker
NAME=cache

mkdir -p /data/data /data/logs
docker rm -f $NAME

docker run --name $NAME -d --restart=always -p 80:80 -v /data/data:/cache -v /data/logs:/var/log/nginx $IMAGE
