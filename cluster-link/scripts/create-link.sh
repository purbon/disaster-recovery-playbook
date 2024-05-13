#!/usr/bin/env bash

docker exec kafka_a kafka-cluster-links --bootstrap-server kafka_b:29093 --create --link dr-link --config bootstrap.servers=kafka_a:29092

echo "waiting..."

sleep 2

docker exec kafka_a kafka-cluster-links --bootstrap-server kafka_b:29093 --list