#!/usr/bin/env bash

set -xe

time terraform apply -var-file="setup.tfvars" -parallelism=20