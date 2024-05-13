#!/usr/bin/env bash

echo "kafka_a:"

curl -s -X GET http://localhost:8091/kafka/v3/clusters/ | jq '.data[0].cluster_id'  

echo ""

echo "kafka_b:"

curl -s -X GET http://localhost:8090/kafka/v3/clusters/ | jq '.data[0].cluster_id'  