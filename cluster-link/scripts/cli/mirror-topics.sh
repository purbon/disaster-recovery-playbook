#!/usr/bin/env bash

docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --create --mirror-topic  topic-topic-source --link dr-link 

echo "waiting..."

sleep 2

docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --list
