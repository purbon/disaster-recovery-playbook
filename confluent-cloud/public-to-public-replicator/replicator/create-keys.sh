#!/usr/bin/env bash

export ENVIRONMENT=<environment>

confluent environment use $ENVIRONMENT

SERVICE_ACCOUNT_ID=`confluent iam service-account create pub-replicator-sa --description "Service Account for Replicator" --output json | jq .id`

echo "Service account created (pub-replicator-sa): "
echo $SERVICE_ACCOUNT_ID


export SOURCE_CLUSTER_ID=<source-cluster-id>
export SOURCE_TOPIC=<source-topic>

export TARGET_CLUSTER_ID=<target-cluster-id>
export TARGET_TOPIC=<target-topic>

confluent api-key create --resource $SOURCE_CLUSTER_ID --service-account $SERVICE_ACCOUNT_ID

#+------------+------------------------------------------------------------------+
#| API Key    | FZ4NVH3ZDBPPQDQF                                                 |
#| API Secret | /jtg9fQ854usKpTM65IT/hOdXs+MjQwsrzQUoMVunCIFxEuiSYM4u4Hu1vsgSWS3 |
#+------------+------------------------------------------------------------------+

confluent api-key create --resource $TARGET_CLUSTER_ID --service-account $SERVICE_ACCOUNT_ID

#+------------+------------------------------------------------------------------+
#| API Key    | XGL6LPEHPHJTV25Y                                                 |
#| API Secret | UZuWm0k7BWlXcDMqfm75O0bXutQsqI5OT+2bidq6usg7nTkaXifXVehyhMsz5k0p |
#+------------+------------------------------------------------------------------+