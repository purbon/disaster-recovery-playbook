#!/usr/bin/env bash

docker exec schema-registry schema-exporter --describe --name dr-exporter --schema.registry.url http://schema-registry:8081/