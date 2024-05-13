#!/usr/bin/env bash

docker exec schema-registry schema-exporter --create --name dr-exporter --subjects ":*:" --config-file /scripts/cli/config.txt --schema.registry.url  http://schema-registry:8081/ --context-type "DEFAULT"