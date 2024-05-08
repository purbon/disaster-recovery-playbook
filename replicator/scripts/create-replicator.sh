#!/usr/bin/env sh

echo "Creating a Replicator"

curl -i -X POST -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/ \
    -d '{
      "name": "kfk-replicator",
      "config": {
               "connector.class":  "io.confluent.connect.replicator.ReplicatorSourceConnector",
               "dest.kafka.bootstrap.servers": "pkc-75m1o.europe-west3.gcp.confluent.cloud:9092",
               "dest.kafka.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"XI73CZWA753ZTGSD\" password=\"nr9P0x7dzyjOIcZjrG7hwdscKggLztAXeoEpELySnl6lyyJdWg6npbIwXlku1XPZ\";",
               "dest.kafka.sasl.mechanism": "PLAIN",
               "dest.kafka.security.protocol": "SASL_SSL",
               "dest.topic.replication.factor": "3",
               "src.kafka.bootstrap.servers": "kafka:9093",
               "src.consumer.group.id": "connect-replicator",
               "src.kafka.timestamps.topic.replication.factor": 1,
               "producer.override.bootstrap.servers": "pkc-75m1o.europe-west3.gcp.confluent.cloud:9092",
               "producer.override.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"XI73CZWA753ZTGSD\" password=\"nr9P0x7dzyjOIcZjrG7hwdscKggLztAXeoEpELySnl6lyyJdWg6npbIwXlku1XPZ\";",
               "producer.override.sasl.mechanism": "PLAIN",
               "producer.override.security.protocol": "SASL_SSL",
               "producer.override.sasl.login.callback.handler.class": "org.apache.kafka.common.security.authenticator.AbstractLogin$DefaultLoginCallbackHandler",
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
