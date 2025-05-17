#!/usr/bin/env bash

# Not sure where yet
cd ~/docker_builds

# All containers in stack
CONTAINERS=($(docker compose config --services))

# Stop all containers
for i in "${CONTAINERS[@]}"
do
    echo "Stopping $i"
    docker stop "$i"
done

cd -
