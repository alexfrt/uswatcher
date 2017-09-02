#!/usr/bin/env bash

set -o errexit -o nounset

. ./vars.sh

echo "--- Stopping containers and network"

if [ "$(docker ps -q -f name=${elasticsearch_id})" ]; then
    echo "-- Stopping and removing the Elasticsearch container"
    docker rm -f ${elasticsearch_id}
fi

if [ "$(docker ps -q -f name=${kibana_id})" ]; then
    echo "-- Stopping and removing the Kibana container"
    docker rm -f ${kibana_id}
fi

if [ "$(docker ps -q -f name=${packetbeat_id})" ]; then
    echo "-- Stopping and removing the PacketBeat container"
    docker rm -f ${packetbeat_id}
fi

if [ "$(docker network ls -q -f name=${network_name})" ]; then
    echo "-- Removing the docker network"
    docker network rm ${network_name}
fi

echo "--- Done"
