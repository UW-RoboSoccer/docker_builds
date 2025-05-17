#!/usr/bin/env bash

cd ~/docker_builds

# All containers in stack
CONTAINERS=($(docker compose config --services))

# Stop all containers
for i in "${CONTAINERS[@]}"
do
    echo "Removing $i"
    docker rm "$i"
done
