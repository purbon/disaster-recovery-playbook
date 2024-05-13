#!/usr/bin/env bash


curl -d "@scripts/rest-api/mirror.json" -H "Content-Type: application/json" -X POST http://localhost:8090/kafka/v3/clusters/24Crq9YxRzuOj52vOunBYQ/links/dr-link/mirrors

curl -X GET  http://localhost:8090/kafka/v3/clusters/24Crq9YxRzuOj52vOunBYQ/links/dr-link/mirrors