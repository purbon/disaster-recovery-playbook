#!/usr/bin/env bash


source cluster-link-rc.sh

# (Optional) Create an API-KEY

# set environment (primary)
confluent environment use $primary_environment
confluent api-key create --resource $primary_id

#+------------+------------------------------------------------------------------+
#| API Key    | AKSXMMXJX5J4MLOY                                                 |
#| API Secret | VLxEWPq+otE0n+Drfo5Pao4LZkpogGUvrvdO39ar7EvEyKU2NHKX+JK0gD0Jcu+X |
#+------------+------------------------------------------------------------------+

# create the link

confluent environment use $secondary_environment

confluent kafka link create dr-link --cluster $secondary_id \
    --source-cluster $primary_id \
    --source-bootstrap-server $primary_endpoint \
    --source-api-key $api_key --source-api-secret $api_secret


## create a mirror topic in the secondary cluster

confluent kafka mirror create orders --cluster $secondary_id --link dr-link

## produce in the principal topic

confluent api-key use XHOWZML6462WD57R --resource $primary_id
seq 1 10 | confluent kafka topic produce orders --cluster $primary_id --environment $primary_environment

## consume from the secondary topic

confluent environment use $secondary_environment
confluent api-key create --resource $secondary_id

#+------------+------------------------------------------------------------------+
#| API Key    | OYMWSYH6Y5WKHKKT                                                 |
#| API Secret | DPxCBRuhcUSfLQYs73oFVto5GpzMJibMzfxcAoL+uRJKpQeDMs6GcrR8gHqS5+v7 |
#+------------+------------------------------------------------------------------+

confluent api-key use OYMWSYH6Y5WKHKKT --resource $secondary_id

confluent kafka topic consume orders --cluster $secondary_id --from-beginning
