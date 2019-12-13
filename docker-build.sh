#!/bin/sh

docker stack rm proxy
sleep 2

cd proxy
docker build -t tourgeek/envoy .
cd ..

docker stack deploy --compose-file docker-compose.yml proxy
