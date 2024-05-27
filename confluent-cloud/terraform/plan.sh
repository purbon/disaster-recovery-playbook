#!/usr/bin/env bash

set -xe

terraform plan -var-file="setup.tfvars" -parallelism=20