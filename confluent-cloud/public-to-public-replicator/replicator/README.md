# Confluent Replicator for Confluent Cloud playbook

This playbook includes an example application on how to use Confluent Replicator for Confluent Cloud.

To run this probe of concept, you will need:

* Two clusters in Confluent Cloud
* To create, and note, the required service account using the create-keys.sh script
* To create the required api-keys to be used to communicate to the source and target clusters.
* To assign the required ACLs to the replicator service account, this can be done using the create-replicator-perm.sh script


To manage the replicator as a connector, this can be run using a local Kafka Connect cluster available via docker compose.
The source cluster credentials will need to be updated in the docker-compose.yml file for this setup to work.

Once the local Kafka Connect cluster is up and running, a replicator can be created using the Postman collections available in the postman-requests directory.
