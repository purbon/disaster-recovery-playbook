#!/usr/bin/env bash

curl --silent -X GET http://localhost:8082/subjects?subjectPrefix=":*:" | jq


docker exec schema-registry schema-exporter --get-status --name dr-exporter --schema.registry.url http://schema-registry:8081