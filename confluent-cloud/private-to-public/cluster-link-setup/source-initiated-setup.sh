#!/usr/bin/env bash


source cluster-link-rc.sh

# (Optional) Create an API-KEY

# set environment (primary)
confluent environment use $primary_environment



## Destination part (private)

confluent kafka link create private-to-public --cluster $secondary_id \
  --config private-destination-link.config \
  --source-cluster $primary_id

## Source part (public)

confluent kafka link create private-to-public \
  --cluster $primary_id \
  --destination-cluster $secondary_id \
  --destination-bootstrap-server $secondary_endpoint \
  --config public-source-link.config


#
#  $ confluent kafka link create private-to-public \                                                                                       ‹system: ruby 2.6.10p210›
#  --cluster $primary_id \
#  --destination-cluster $secondary_id \
#  --destination-bootstrap-server $secondary_endpoint \
#  --config public-source-link.config
#Error: REST request failed: Invalid Cluster Link: Invalid cluster link. Link error code: BOOTSTRAP_TCP_CONNECTION_FAILED_ERROR. Link error message: Failed to create a TCP connection to the destination cluster. Please ensure the destination cluster is running and is reachable by the source cluster.. Error message: Unable to validate cluster link due to error: The provided cluster is invalid.
#