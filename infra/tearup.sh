#!/usr/bin/env bash

set -o errexit -o nounset

. ./vars.sh

if [ ! "$(docker network ls -q -f name=${network_name})" ]; then
    echo "-- Creating docker network"
    docker network create --subnet=${network_range} ${network_name}
fi

if [ ! "$(docker ps -q -f name=${elasticsearch_id})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${elasticsearch_id})" ]; then
        echo "-- Removing old Elasticsearch container"
        docker rm ${elasticsearch_id}
    fi

    echo "-- Running Elasticsearch container"
    docker run --name ${elasticsearch_id} --ip ${elasticsearch_ip} --network ${network_name} -d elasticsearch:5.5.2
fi

if [ ! "$(docker ps -q -f name=${kibana_id})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${kibana_id})" ]; then
        echo "-- Removing old Kibana container"
        docker rm ${kibana_id}
    fi

    echo "-- Running Kibana container"
    docker run --name ${kibana_id} --ip ${kibana_ip} --network ${network_name} -d kibana:5.5.2
fi

if [ ! "$(docker ps -q -f name=${packetbeat_id})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${packetbeat_id})" ]; then
        echo "-- Removing old PacketBeat container"
        docker rm ${packetbeat_id}
    fi

    echo "-- Building packetbeat container"
    cd packetbeat
    docker build -t ${packetbeat_image} .
    cd ..

    if [ "$(docker ps -q -f name=${packetbeat_id})" ]; then
        echo "-- Replacing the current packetbeat container for the new one"
        docker rm -f ${packetbeat_id}
    fi

    echo "-- Waiting 10 seconds until Elasticsearch goes up"
    sleep 10

    echo "-- Running PacketBeat container"
    docker run --name ${packetbeat_id} --ip ${packetbeat_ip} --network ${network_name} --privileged -d ${packetbeat_image}

    echo "-- Configuring Kibana dashboards for Packetbeat"
    docker run --rm --network ${network_name} docker.elastic.co/beats/packetbeat:5.5.2 ./scripts/import_dashboards -es http://${elasticsearch_id}:9200
fi
