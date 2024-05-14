#!/usr/bin/env bash

docker-compose  exec kafka_a kafka-console-producer --broker-list kafka_a:29092 --topic topic-topic-source 

docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_a:29092 --topic topic-topic-source --from-beginning 