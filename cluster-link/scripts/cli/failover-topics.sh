#!/usr/bin/env bash

docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --failover --topics  topic-topic-source

echo "waiting..."

sleep 2

docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --describe
