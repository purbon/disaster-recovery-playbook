#!/usr/bin/env bash

set -xe

time terraform apply -var-file="terraform.tfvars" -parallelism=20