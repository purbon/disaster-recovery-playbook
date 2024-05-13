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
               "topic.whitelist": "topic-topic-source",
               "key.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
               "value.converter": "io.confluent.connect.replicator.util.ByteArrayConverter"
      }
    }'

sleep 5

#       CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL: 'http://schema-registry:8081'
# "transforms": "ExtractField",
# "transforms.ExtractField.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
# "transforms.ExtractField.field":"after"
#                "producer.override.sasl.login.callback.handler.class": "org.apache.kafka.common.security.authenticator.AbstractLogin$DefaultLoginCallbackHandler",


docker exec kafka_a kafka-cluster-links --bootstrap-server kafka_b:29093 --create --link demo-link --config bootstrap.servers=kafka_a:29092

docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --create --mirror-topic  topic-topic-source --link demo-link 

docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --list

docker exec kafka_b kafka-topics --bootstrap-server kafka_b:29093 --list

docker-compose  exec kafka_a kafka-console-producer --broker-list kafka_a:29092 --topic topic-topic-source 

docker-compose exec kafka_b kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic topic-topic-source --from-beginning 