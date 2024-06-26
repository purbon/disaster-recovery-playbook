#!/usr/bin/env sh

echo "Creating a Replicator"

curl -i -X POST -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/ \
    -d '{
      "name": "kfk-replicator",
      "config": {
               "connector.class":  "io.confluent.connect.replicator.ReplicatorSourceConnector",
               "dest.kafka.bootstrap.servers": "kafka_b:29094",
               "dest.kafka.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"kafka\" password=\"kafka\";",
               "dest.kafka.sasl.mechanism": "PLAIN",
               "dest.kafka.security.protocol": "SASL_PLAINTEXT",
               "dest.topic.replication.factor": "1",
               "src.kafka.bootstrap.servers": "kafka_a:29092",
               "src.consumer.group.id": "connect-replicator",
               "src.kafka.timestamps.topic.replication.factor": 1,
               "confluent.topic.replication.factor": 1,
               "producer.override.bootstrap.servers": "kafka_b:29094",
               "producer.override.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"kafka\" password=\"kafka\";",
               "producer.override.sasl.mechanism": "PLAIN",
               "producer.override.security.protocol": "SASL_PLAINTEXT",
               "tasks.max": "2",
               "offset.translator.tasks.max": "1",
               "offset.translator.tasks.separate": "true",
               "offset.translator.batch.period.ms": "10000",
               "provenance.header.enable": "true",
               "topic.whitelist": "topic.topic.source",
               "key.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
               "value.converter": "io.confluent.connect.replicator.util.ByteArrayConverter"
      }
    }'

sleep 5