#!/usr/bin/env bash

docker-compose  exec kafka_a kafka-console-producer --broker-list kafka_b:29093 --topic topic.topic.source 

docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic topic.topic.source --from-beginning 

docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic source.in --from-beginning 