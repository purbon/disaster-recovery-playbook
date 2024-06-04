# Confluent Cloud disaster recovery playbook (private-to-private)

This playbook contains examples on how to use the Cluster Linking in Confluent Cloud for connecting two Kafka(s) and implement a Disaster Recovery solution.

## Setup

* A primary cluster, on its dedicated environment, deployed in eu-central-1. Protected with Privatelink in AWS.
* A secondary cluster, including a dedicated environment, deployed in eu-west-3. Protected with Privatelink in AWS.

## Preparation

To make the reproduction of this test bed easier a custom tailored terraform modules are included in the [cluster_a](terraform/cluster_a/) and [cluster_b](terraform/cluster_b/) directories.
To run create the clusters, please create a file called *terraform.tfvars*, see the reference content [here](terraform/terraform.tfvars).

*Note*, this repository containss multiple terraforms modules, dedicated to each cluster (a and b):

* [dedicated-privatelink-aws](terraform/cluster_a/dedicated-privatelink-aws/) to create a public accessible dedicated cluster in Confluent Cloud.
* (Optional) [aws-vpc-provision](terraform/cluster_a/aws-vpc-provision/) to create a mock VPC and EC2 instance for a proxy in AWS.

As well, you will find a reference file to setup an nginx proxy [here](terraform/cluster_a/proxy/).

## Network service links

The first setup when creating cluster links where both nodes are in private networks is to create a network service, the commands required can be found in [network-links.sh](network-links.sh), note the order mathers:

* Create a network service in the source network.
* Create a network endpoint in the target network.

Example commands looks like:

```bash
confluent network link service create dr-link-service \
  --network n-jvxyww \
  --description "disaster recovery network link service" \
  --accepted-environments env-m25yq1
```

```bash
  confluent network link endpoint create dr-link-endpoint \
  --network n-jq43wy \
  --description "disaster recovery network link service" \
  --network-link-service nls-61er9o
```


More details about this step can be found [here](https://docs.confluent.io/cloud/current/networking/network-linking.html).

## Cluster link creation

Once the dedicated infra is available, either for test, or directly from your own setup, you can use the script [cluster-link-setup.sh](cluster-link-setup.sh) that contains all the required commands to configure a destination initiated link.
As a summary, please note:

```bash
confluent kafka link create dr-link --cluster $secondary_id \
    --source-cluster $primary_id \
    --source-bootstrap-server $primary_endpoint \
    --source-api-key $api_key --source-api-secret $api_secret
```

will create a destination initiated link, starting from the secondary (DR) cluster, reading all mirrored topics from the primary cluster.
You can see the configuration if you use the following command

