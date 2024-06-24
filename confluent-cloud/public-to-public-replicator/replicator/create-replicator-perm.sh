#!/usr/bin/env bash


export ENVIRONMENT=<environment>

export SOURCE_CLUSTER_ID=<source-cluster-id>
export SOURCE_TOPIC=<source-topic>

export TARGET_CLUSTER_ID=<target-cluster-id>
export TARGET_TOPIC=<target-topic>

export SERVICE_ACCOUNT_ID=<service-account-id>

confluent environment use $ENVIRONMENT

confluent kafka cluster use $SOURCE_CLUSTER_ID
# ACLs to Read from the Source Cluster 
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID  --operations DESCRIBE --cluster-scope
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID  --operations DESCRIBE --cluster $SOURCE_CLUSTER_ID
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID  --operations DESCRIBE --topic $SOURCE_TOPIC
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID  --operations READ --topic $SOURCE_TOPIC

# ACLs for Topic Creation and Config Sync
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --topic $SOURCE_TOPIC
#confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --cluster-scope


# ACLs for License Management
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations CREATE --topic _confluent-command
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --topic _confluent-command
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --topic _confluent-command
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --topic _confluent-command
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --topic _confluent-command
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations ALTER-CONFIGS --topic _confluent-command


confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations create --cluster-scope
#confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations describe --cluster-scope

# ACLs for Source Offset Management
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations CREATE --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations ALTER-CONFIGS --consumer-group "*"


# ACLS for _consumer_timestamps

confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations CREATE --topic __consumer_timestamps
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --topic __consumer_timestamps
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --topic __consumer_timestamps
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --topic __consumer_timestamps
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --topic __consumer_timestamps
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations ALTER-CONFIGS --topic __consumer_timestamps

# write to target cluster
confluent kafka cluster use $TARGET_CLUSTER_ID

confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --cluster-scope
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --cluster $TARGET_CLUSTER_ID
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --topic $TARGET_TOPIC
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --topic $TARGET_TOPIC
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --topic $TARGET_TOPIC


# ACLs for Topic Creation and Config Sync
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --topic $TARGET_TOPIC
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations CREATE --cluster $TARGET_CLUSTER_ID
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations ALTER-CONFIGS --cluster $TARGET_CLUSTER_ID

# topic creation and config sync

confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --topic $SOURCE_TOPIC
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --topic $TARGET_TOPIC
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations CREATE --cluster-scope
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations ALTER-CONFIGS --cluster-scope
#confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --cluster-scope

# ACLs for Offset Translation

confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations CREATE --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations WRITE --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations READ --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations DESCRIBE-CONFIGS --consumer-group "*"
confluent kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operations ALTER-CONFIGS --consumer-group "*"
