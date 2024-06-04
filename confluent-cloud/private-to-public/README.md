# Confluent Cloud disaster recovery playbook (private-to-public)

This playbook contains examples on how to use the Cluster Linking in Confluent Cloud for connecting two Kafka(s) and implement a Disaster Recovery solution.

## Setup

* A primary cluster, on its dedicated environment, deployed in eu-central-1
* A secondary cluster, including a dedicated environment, deployed in eu-west-3. Protected with Privatelink in AWS.

## Preparation

To make the reproduction of this test bed easier a custom tailored terraform module is included in the [Terraform](terraform) folder.
To run create the clusters, please create a file called *terraform.tfvars*, see the reference content [here](terraform/terraform.tfvars).

*Note*, this repository containts multiple terraforms modules:

* [dedicated-public](terraform/dedicated-public/) to create a public accessible dedicated cluster in Confluent Cloud.
* [dedicated-privatelink-aws](terraform/dedicated-privatelink-aws/) to create a public accessible dedicated cluster in Confluent Cloud.
* (Optional) [aws-vpc-provision](terraform/aws-vpc-provision/) to create a mock VPC and EC2 instance for a proxy in AWS.


## Cluster link creation

Once the dedicated infra is available, either for test, or directly from your own setup, you can use the script [cluster-link-setup.sh](cluster-link-setup/cluster-link-setup.sh) that contains all the required commands to configure a destination initiated link.
As a summary, please note:

```bash
confluent kafka link create dr-link --cluster $secondary_id \
    --source-cluster $primary_id \
    --source-bootstrap-server $primary_endpoint \
    --source-api-key $api_key --source-api-secret $api_secret
```

will create a destination initiated link, starting from the secondary (DR) cluster, reading all mirrored topics from the primary cluster.
You can see the configuration if you use the following command

```bash
confluent kafka link configuration list dr-link  --cluster $secondary_id
```

where you will notice:

```bash
link_mode = DESTINATION # private-link cluster
connection.mode = OUTBOUND # default
```

as with any other links, you can do a mirror topic by:

```bash
confluent kafka mirror create orders --cluster $secondary_id --link dr-link
```