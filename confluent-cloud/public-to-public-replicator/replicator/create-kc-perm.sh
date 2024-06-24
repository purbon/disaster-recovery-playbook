#!/usr/bin/env bash

export ENVIRONMENT=<environment>

export SOURCE_CLUSTER_ID=<source-cluster-id>
export SOURCE_TOPIC=<source-topic>

export TARGET_CLUSTER_ID=<target-cluster-id>
export TARGET_TOPIC=<target-topic>

export SERVICE_ACCOUNT_ID=<service-account-id>

confluent environment use $ENVIRONMENT
confluent kafka cluster use $SOURCE_CLUSTER_ID

confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations CREATE --cluster-scope
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --topic kafka-connect-status
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --topic kafka-connect-status
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --topic kafka-connect-offsets
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --topic kafka-connect-offsets
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --topic kafka-connect-configs
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --topic kafka-connect-configs
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --consumer-group "*"
