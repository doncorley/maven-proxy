#!/bin/sh

docker stack rm proxy
sleep 4

cd proxy
docker build -t tourgeek/envoy .
cd ..

docker stack deploy --compose-file proxy/docker-compose.yml proxy
