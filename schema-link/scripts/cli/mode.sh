#!/usr/bin/env bash

## List
curl -X GET http://localhost:8082/mode

## Change

curl -d '{ "mode": "READWRITE"}' -H "Content-Type: application/json" -X PUT http://localhost:8082/mode?force=true