# Confluent Cluster linking playbook

This playbook contains examples on how to use the Confluent Cluster link for connecting two Kafka(s) and implement a Disaster Recovery solution.

## Setup

* A primary cluster (kafka_a): 
    * 1 node Apache Kafka
    * 1 node Apache Zookeeper
* A secondary cluster (kafka_b):
    * 1 node Apache Kafka
    * 1 node Apache Zookeeper

*Note*, this setup is for playground objective, it is not intended to reproduce a real production environment. 

## Pre-requisites

To run this setup successfully you need Docker Desktop, including docker compose available in your local machine.

## Playbook

### Startup

```bash
$ ./up                                                                                                                                                                                                                             ‹system: ruby 2.6.10p210›
[+] Building 1.4s (31/31) FINISHED                                                                                                                                                                                                      docker:desktop-linux
 => [kafka_b internal] load build definition from Dockerfile                                                                                                                                                                                            0.0s
 => => transferring dockerfile: 805B                                                                                                                                                                                                                    0.0s
 => [kafka_b internal] load .dockerignore                                                                                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                                                                                         0.0s
 => [kafka_b internal] load metadata for docker.io/library/fedora:41                                                                                                                                                                                    1.3s
 => [kafka_a internal] load build definition from Dockerfile                                                                                                                                                                                            0.0s
 => => transferring dockerfile: 805B                                                                                                                                                                                                                    0.0s
 => [kafka_a internal] load .dockerignore                                                                                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                                                                                         0.0s
 => [kafka_b  1/12] FROM docker.io/library/fedora:41@sha256:7dfa0287e66691369cf8ba4a7be39c21af8e4663c3c9a854c5ebb221bfbb7947                                                                                                                            0.0s
 => [kafka_a internal] load build context                                                                                                                                                                                                               0.0s
 => => transferring context: 331B                                                                                                                                                                                                                       0.0s
 => [kafka_b internal] load build context                                                                                                                                                                                                               0.0s
 => => transferring context: 331B                                                                                                                                                                                                                       0.0s
 => CACHED [kafka_a  2/12] RUN rpm --import https://packages.confluent.io/rpm/7.6/archive.key                                                                                                                                                           0.0s
 => CACHED [kafka_b  3/12] COPY confluent.repo /etc/yum.repos.d/confluent.repo                                                                                                                                                                          0.0s
 => CACHED [kafka_b  4/12] RUN yum clean all                                                                                                                                                                                                            0.0s
 => CACHED [kafka_b  5/12] RUN yum install -y java-11-openjdk-devel                                                                                                                                                                                     0.0s
 => CACHED [kafka_b  6/12] RUN yum install -y curl which                                                                                                                                                                                                0.0s
 => CACHED [kafka_b  7/12] RUN yum install -y confluent-server confluent-security confluent-schema-registry                                                                                                                                             0.0s
 => CACHED [kafka_b  8/12] COPY kafka.properties /etc/kafka/server.properties                                                                                                                                                                           0.0s
 => CACHED [kafka_b  9/12] COPY log4j.properties /etc/kafka/log4j.propertie                                                                                                                                                                             0.0s
 => CACHED [kafka_b 10/12] COPY kafka_server_jaas.conf /etc/kafka/kafka_server_jaas.conf                                                                                                                                                                0.0s
 => CACHED [kafka_b 11/12] COPY alice.properties /etc/kafka/alice.properties                                                                                                                                                                            0.0s
 => CACHED [kafka_b 12/12] COPY bob.properties /etc/kafka/bob.properties                                                                                                                                                                                0.0s
 => CACHED [kafka_a  3/12] COPY confluent.repo /etc/yum.repos.d/confluent.repo                                                                                                                                                                          0.0s
 => CACHED [kafka_a  4/12] RUN yum clean all                                                                                                                                                                                                            0.0s
 => CACHED [kafka_a  5/12] RUN yum install -y java-11-openjdk-devel                                                                                                                                                                                     0.0s
 => CACHED [kafka_a  6/12] RUN yum install -y curl which                                                                                                                                                                                                0.0s
 => CACHED [kafka_a  7/12] RUN yum install -y confluent-server confluent-security confluent-schema-registry                                                                                                                                             0.0s
 => CACHED [kafka_a  8/12] COPY kafka.properties /etc/kafka/server.properties                                                                                                                                                                           0.0s
 => CACHED [kafka_a  9/12] COPY log4j.properties /etc/kafka/log4j.propertie                                                                                                                                                                             0.0s
 => CACHED [kafka_a 10/12] COPY kafka_server_jaas.conf /etc/kafka/kafka_server_jaas.conf                                                                                                                                                                0.0s
 => CACHED [kafka_a 11/12] COPY alice.properties /etc/kafka/alice.properties                                                                                                                                                                            0.0s
 => CACHED [kafka_a 12/12] COPY bob.properties /etc/kafka/bob.properties                                                                                                                                                                                0.0s
 => [kafka_a] exporting to image                                                                                                                                                                                                                        0.0s
 => => exporting layers                                                                                                                                                                                                                                 0.0s
 => => writing image sha256:8e08242bffad251fe9537abe3cfcf4b86ef7b40574ae4bf85060a764674e8095                                                                                                                                                            0.0s
 => => naming to docker.io/library/cluster-link-kafka_a                                                                                                                                                                                                 0.0s
 => [kafka_b] exporting to image                                                                                                                                                                                                                        0.0s
 => => exporting layers                                                                                                                                                                                                                                 0.0s
 => => writing image sha256:b06505f0fa76db36b5a7121b55dab6d7f17e56be7b9841374243cb3e4e6c4f3f                                                                                                                                                            0.0s
 => => naming to docker.io/library/cluster-link-kafka_b                                                                                                                                                                                                 0.0s
[+] Running 4/4
 ✔ Container zookeeper    Started                                                                                                                                                                                                                       0.0s 
 ✔ Container zookeeper_b  Started                                                                                                                                                                                                                       0.0s 
 ✔ Container kafka_b      Started                                                                                                                                                                                                                       0.0s 
 ✔ Container kafka_a      Started                                                                                                                                                                                                                       0.0s 
Example configuration:
-> docker-compose exec kafka kafka-console-producer --broker-list kafka:9093 --producer.config /etc/kafka/consumer.properties --topic test
-> docker-compose exec kafka kafka-console-consumer --bootstrap-server kafka:9093 --consumer.config /etc/kafka/consumer.properties --topic test --from-beginning
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
[2024-05-14 13:19:00,955] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.5:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 13:19:01,087] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.5:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 13:19:01,288] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.5:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 13:19:01,490] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.5:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 13:19:01,904] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.5:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 13:19:02,625] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.5:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 13:19:03,632] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.5:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
Created topic __consumer_timestamps.
Created topic topic-topic-source.
```
### Produce some messages for the principal cluster

```bash
$ docker-compose  exec kafka_a kafka-console-producer --broker-list kafka_a:29092 --topic topic-topic-source                                                                                                                       ‹system: ruby 2.6.10p210›
>message 1
>message 2
>message 3
>message 4
>^C%     
```
Check the produced messages by using:

```bash
$ docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_a:29092 --topic topic-topic-source --from-beginning                                                                                                 ‹system: ruby 2.6.10p210›
message 1
message 2
message 3
^C
Processed a total of 3 messages
```

### Setup the cluster link (create the link)

```bash
$ docker exec kafka_a kafka-cluster-links --bootstrap-server kafka_b:29093 --create --link dr-link --config bootstrap.servers=kafka_a:29092                                                                                        ‹system: ruby 2.6.10p210›

Cluster link 'dr-link' creation successfully completed.
```

```bash
$ docker exec kafka_a kafka-cluster-links --bootstrap-server kafka_b:29093 --list                                                                                                                                                  ‹system: ruby 2.6.10p210›
Link name: 'dr-link', link ID: 'Ce2MZ4pxSESkGapcKy0nww', remote cluster ID: 'DebMIDaMROq-w8biGJB3qA', local cluster ID: 'V1EhTri7Qee8K2zsYb-Tng', remote cluster available: 'true', link state: 'ACTIVE'
```

## Create the mirror topics

```bash
$ docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --create --mirror-topic  topic-topic-source --link dr-link                                                                                                    ‹system: ruby 2.6.10p210›

Created topic topic-topic-source.
```

```bash
docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --describe                                                                                                                                                    ‹system: ruby 2.6.10p210›

Topic: topic-topic-source       LinkName: dr-link       LinkId: Ce2MZ4pxSESkGapcKy0nww  SourceTopic: topic-topic-source State: ACTIVE   SourceTopicId: Qjgz1WvjS--WbWoLExbSeA   StateTime: 2024-05-14 13:26:38
        Partition: 0    State: ACTIVE   DestLogEndOffset: 0     LastFetchSourceHighWatermark: -1        Lag: -1 TimeSinceLastFetchMs: 1715693222270
        Partition: 1    State: ACTIVE   DestLogEndOffset: 0     LastFetchSourceHighWatermark: 0 Lag: 0  TimeSinceLastFetchMs: 23105
        Partition: 2    State: ACTIVE   DestLogEndOffset: 3     LastFetchSourceHighWatermark: -1        Lag: -1 TimeSinceLastFetchMs: 1715693222270
```

### Verify the messages in the secondary cluster

```bash
$ docker-compose exec kafka_b kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic topic-topic-source --from-beginning                                                                                                 ‹system: ruby 2.6.10p210›
message 1
message 2
message 3
^C
Processed a total of 3 messages
```

### Failover the mirrored topics

```bash
$ docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --failover --topics  topic-topic-source                                                                                                                       ‹system: ruby 2.6.10p210›

Request for stopping topic topic-topic-source's mirror was successfully scheduled. Please use the describe command with the --pending-stopped-only option to monitor progress.
```

```bash
 docker exec kafka_a kafka-mirrors --bootstrap-server kafka_b:29093 --describe                                                                                                                                                    ‹system: ruby 2.6.10p210›

No mirror topics found.
```


## Tear down

```bash
$ docker-compose down                                                                                                                                                                                                              ‹system: ruby 2.6.10p210›
[+] Running 5/4
 ✔ Container kafka_a             Removed                                                                                                                                                                                                                1.4s 
 ✔ Container kafka_b             Removed                                                                                                                                                                                                                1.3s 
 ✔ Container zookeeper_b         Removed                                                                                                                                                                                                                0.5s 
 ✔ Container zookeeper           Removed                                                                                                                                                                                                                0.4s 
 ✔ Network cluster-link_default  Removed  
```

