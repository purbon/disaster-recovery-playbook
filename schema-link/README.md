# Confluent Schema linking playbook

This playbook contains examples on how to use the Confluent Cluster link for connecting two Kafka(s) and implement a Disaster Recovery solution.

## Setup

* A primary cluster (kafka_a): 
    * 1 node Apache Kafka
    * 1 node Apache Zookeeper
    * 1 node Schema Registry
* A secondary cluster (kafka_b):
    * 1 node Apache Kafka
    * 1 node Apache Zookeeper
    * 1 node Schema Registry

*Note*, this setup is for playground objective, it is not intended to reproduce a real production environment. 

## Pre-requisites

To run this setup successfully you need Docker Desktop, including docker compose available in your local machine.

## Playbook

### Startup

```bash
$ ./up                                                                                                                                                                                                                             ‹system: ruby 2.6.10p210›
[+] Building 2.3s (31/31) FINISHED                                                                                                                                                                                                      docker:desktop-linux
 => [kafka_b internal] load build definition from Dockerfile                                                                                                                                                                                            0.0s
 => => transferring dockerfile: 805B                                                                                                                                                                                                                    0.0s
 => [kafka_b internal] load .dockerignore                                                                                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                                                                                         0.0s
 => [kafka_a internal] load metadata for docker.io/library/fedora:41                                                                                                                                                                                    2.2s
 => [kafka_a internal] load .dockerignore                                                                                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                                                                                         0.0s
 => [kafka_a internal] load build definition from Dockerfile                                                                                                                                                                                            0.0s
 => => transferring dockerfile: 805B                                                                                                                                                                                                                    0.0s
 => [kafka_b internal] load build context                                                                                                                                                                                                               0.0s
 => => transferring context: 3.33kB                                                                                                                                                                                                                     0.0s
 => [kafka_a  1/12] FROM docker.io/library/fedora:41@sha256:7dfa0287e66691369cf8ba4a7be39c21af8e4663c3c9a854c5ebb221bfbb7947                                                                                                                            0.0s
 => [kafka_a internal] load build context                                                                                                                                                                                                               0.0s
 => => transferring context: 3.32kB                                                                                                                                                                                                                     0.0s
 => CACHED [kafka_b  2/12] RUN rpm --import https://packages.confluent.io/rpm/7.6/archive.key                                                                                                                                                           0.0s
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
 => [kafka_b] exporting to image                                                                                                                                                                                                                        0.0s
 => => exporting layers                                                                                                                                                                                                                                 0.0s
 => => writing image sha256:c9388911d962fac1ff70280760fa0d4e19c73d17862f2d00cfaf5b7eb3b3393c                                                                                                                                                            0.0s
 => => naming to docker.io/library/schema-link-kafka_b                                                                                                                                                                                                  0.0s
 => [kafka_a] exporting to image                                                                                                                                                                                                                        0.0s
 => => exporting layers                                                                                                                                                                                                                                 0.0s
 => => writing image sha256:5157fd7228cc445d6464936e63184ae106e850046c68018c892a51df021415f8                                                                                                                                                            0.0s
 => => naming to docker.io/library/schema-link-kafka_a                                                                                                                                                                                                  0.0s
[+] Running 7/7
 ✔ Network schema-link_default  Created                                                                                                                                                                                                                 0.0s 
 ✔ Container zookeeper          Started                                                                                                                                                                                                                 0.1s 
 ✔ Container zookeeper_b        Started                                                                                                                                                                                                                 0.1s 
 ✔ Container kafka_a            Started                                                                                                                                                                                                                 0.0s 
 ✔ Container kafka_b            Started                                                                                                                                                                                                                 0.0s 
 ✔ Container schema-registry    Started                                                                                                                                                                                                                 0.0s 
 ✔ Container schema-registry_b  Started                                                                                                                                                                                                                 0.0s 
Example configuration:
-> docker-compose exec kafka kafka-console-producer --broker-list kafka:9093 --producer.config /etc/kafka/consumer.properties --topic test
-> docker-compose exec kafka kafka-console-consumer --bootstrap-server kafka:9093 --consumer.config /etc/kafka/consumer.properties --topic test --from-beginning
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
[2024-05-14 14:15:56,880] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 14:15:56,984] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 14:15:57,186] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 14:15:57,387] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 14:15:57,790] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 14:15:58,694] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Node may not be available. (org.apache.kafka.clients.NetworkClient)
Created topic __consumer_timestamps.
Created topic topic-topic-source.
```


### Create a schema in the source

```bash
$ curl -X POST -H "Content-Type: application/json" --data @scripts/schema.avro  http://localhost:8081/subjects/donuts/versions                                                                                                     ‹system: ruby 2.6.10p210›

{"id":1}%  
```

### Create the required schema exporters

```bash
 docker exec schema-registry schema-exporter --create --name dr-exporter --subjects ":*:" --config-file /scripts/cli/config.txt --schema.registry.url  http://schema-registry:8081/ --context-type "DEFAULT"                      ‹system: ruby 2.6.10p210›
Successfully created exporter dr-exporter
```

### Get the status of an exporter

```bash
$ docker exec schema-registry schema-exporter --get-status --name dr-exporter --schema.registry.url http://schema-registry:8081                                                                                                    ‹system: ruby 2.6.10p210›
{"name":"dr-exporter","state":"RUNNING","offset":2,"ts":1715696208353,"deksOffset":-1,"deksTs":0}
```

### Verify the exporter schemas

```bash
$ curl --silent -X GET http://localhost:8082/subjects\?subjectPrefix\=":*:" | jq                                                                                                                                                   ‹system: ruby 2.6.10p210›

[
  "donuts"
]
```

### Change the Schema Registry working mode

```bash
$ curl -X GET http://localhost:8082/mode                                                                                                                                                                                           ‹system: ruby 2.6.10p210›

{"mode":"IMPORT"}% 
```

```bash
$ curl -d '{ "mode": "READWRITE"}' -H "Content-Type: application/json" -X PUT http://localhost:8082/mode\?force\=true                                                                                                              ‹system: ruby 2.6.10p210›
{"mode":"READWRITE"}%    
```

## Tear down

```bash
$ docker-compose down                                                                                                                                                                                                              ‹system: ruby 2.6.10p210›
[+] Running 7/6
 ✔ Container schema-registry_b  Removed                                                                                                                                                                                                                 1.5s 
 ✔ Container schema-registry    Removed                                                                                                                                                                                                                 1.4s 
 ✔ Container kafka_a            Removed                                                                                                                                                                                                                 1.1s 
 ✔ Container kafka_b            Removed                                                                                                                                                                                                                 1.1s 
 ✔ Container zookeeper          Removed                                                                                                                                                                                                                 0.5s 
 ✔ Container zookeeper_b        Removed                                                                                                                                                                                                                 0.4s 
 ✔ Network schema-link_default  Removed  
```