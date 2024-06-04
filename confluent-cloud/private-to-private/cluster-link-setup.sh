#!/usr/bin/env bash


source cluster-link-rc.sh

# (Optional) Create an API-KEY

# set environment (primary)
confluent environment use $primary_environment
confluent api-key create --resource $primary_id

#+------------+------------------------------------------------------------------+
#| API Key    | YHAMQSK5DFYAW4A3                                                 |
#| API Secret | FYjjZmWd+qz5uxlH+wCQJ0stZUzEOV3hNRfUWJk1IXAmcVu/OhmZGTMaZQhlfU5g |
#+------------+------------------------------------------------------------------+

# create the link

confluent environment use $secondary_environment

confluent kafka link create dr-link --cluster $secondary_id \
    --source-cluster $primary_id \
    --source-bootstrap-server $primary_endpoint \
    --source-api-key $api_key --source-api-secret $api_secret


confluent api-key create --resource $secondary_id

#+------------+------------------------------------------------------------------+
#| API Key    | GIDGQ7DTSYKKCOWG                                                 |
#| API Secret | 66yQI5gRzJtUN4l0nCUOrpr250APoi67ybxuYwDEIK2n39POFqBpl9rXCqABwf9y |
#+------------+------------------------------------------------------------------+


confluent kafka link create dr-link --cluster $primary_id \
  --source-cluster $secondary_id \
  --source-bootstrap-server $secondary_endpoint \
  --source-api-key $api_key --source-api-secret $api_secret


## create a mirror topic in the secondary cluster

confluent kafka mirror create sample_data --cluster $secondary_id --link dr-link


#Created mirror topic "sample_data".
