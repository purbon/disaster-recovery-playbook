#!/usr/bin/env bash

curl -X POST -H "Content-Type: application/json" --data @scripts/schema.avro  http://localhost:8081/subjects/donuts/versions
