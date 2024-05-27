#!/usr/bin/env bash

set -xe

terraform apply -var-file="setup.tfvars" -parallelism=20