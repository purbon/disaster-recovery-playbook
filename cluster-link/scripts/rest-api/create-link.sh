#!/usr/bin/env bash

curl -d "@scripts/rest-api/create-link.json" -H "Content-Type: application/json" -X POST http://localhost:8090/kafka/v3/clusters/24Crq9YxRzuOj52vOunBYQ/links?link_name=dr-link