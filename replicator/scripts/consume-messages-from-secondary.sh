#!/usr/bin/env bash

docker-compose  exec kafka_a kafka-console-producer --broker-list kafka_b:29093 --topic topic.topic.source 

docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic topic.topic.source --from-beginning 

docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic source.in --from-beginning 

## Consume the __consumer_timestamp topic:

#export CLASSPATH=/usr/share/java/kafka-connect-replicator/*
export CLASSPATH=/usr/share/confluent-hub-components/confluentinc-kafka-connect-replicator/lib/*
kafka-console-consumer --topic __consumer_timestamps --bootstrap-server kafka_a:29092 \
                       --property print.key=true --property key.deserializer=io.confluent.connect.replicator.offsets.GroupTopicPartitionDeserializer \
                       --property value.deserializer=io.confluent.connect.replicator.offsets.TimestampAndDeltaDeserializer --from-beginning 