# Confluent Replicator playbook

This playbook contains examples on how to use the Confluent Replicator for connecting two Kafka(s) and implement a Disaster Recovery solution.

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

To start the required infrastructure, run this command:

```bash
$ ./up                                                                                                                                                                                                            ‹system: ruby 2.6.10p210›
[+] Building 1.8s (7/7) FINISHED                                                                                                                                                                                       docker:desktop-linux
 => [kafka-connect internal] load build definition from Dockerfile                                                                                                                                                                     0.0s
 => => transferring dockerfile: 450B                                                                                                                                                                                                   0.0s
 => [kafka-connect internal] load .dockerignore                                                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                                                                        0.0s
 => [kafka-connect internal] load metadata for docker.io/confluentinc/cp-kafka-connect:7.5.0                                                                                                                                           1.7s
 => [kafka-connect install-connectors 1/2] FROM docker.io/confluentinc/cp-kafka-connect:7.5.0@sha256:09356387a73723692aa0c7aa60eb259c1e7d57c74da2ac8ced768617613739ce                                                                  0.0s
 => CACHED [kafka-connect install-connectors 2/2] RUN confluent-hub install --no-prompt confluentinc/kafka-connect-replicator:7.5.0                                                                                                    0.0s
 => CACHED [kafka-connect stage-1 2/2] COPY --from=install-connectors /usr/share/confluent-hub-components/ /usr/share/confluent-hub-components/                                                                                        0.0s
 => [kafka-connect] exporting to image                                                                                                                                                                                                 0.0s
 => => exporting layers                                                                                                                                                                                                                0.0s
 => => writing image sha256:6feffd9df0c5ed8368ca6a0ce6b7e82c709a6ca91bd45e8bf3596ab72dd70d4d                                                                                                                                           0.0s
 => => naming to docker.io/library/replicator-kafka-connect                                                                                                                                                                            0.0s
[+] Running 6/6
 ✔ Network replicator_default  Created                                                                                                                                                                                                 0.0s 
 ✔ Container zookeeper_b       Started                                                                                                                                                                                                 0.0s 
 ✔ Container zookeeper         Started                                                                                                                                                                                                 0.0s 
 ✔ Container kafka_b           Started                                                                                                                                                                                                 0.0s 
 ✔ Container kafka_a           Started                                                                                                                                                                                                 0.0s 
 ✔ Container kafka-connect     Started                                                                                                                                                                                                 0.0s 
Example configuration:
-> docker-compose exec kafka kafka-console-producer --broker-list kafka:9093 --producer.config /etc/kafka/consumer.properties --topic test
-> docker-compose exec kafka kafka-console-consumer --bootstrap-server kafka:9093 --consumer.config /etc/kafka/consumer.properties --topic test --from-beginning
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic __consumer_timestamps.
Created topic topic-topic-source.
```

after that you should have the following containers running:

```bash
$ docker ps -a                                                                                                                                                                                                    ‹system: ruby 2.6.10p210›
CONTAINER ID   IMAGE                                    COMMAND                  CREATED              STATUS                                 PORTS                              NAMES
23c087728084   replicator-kafka-connect                 "/etc/confluent/dock…"   About a minute ago   Up About a minute (health: starting)   0.0.0.0:8083->8083/tcp, 9092/tcp   kafka-connect
8e2878a0feec   confluentinc/cp-enterprise-kafka:7.6.1   "/etc/confluent/dock…"   About a minute ago   Up About a minute                      0.0.0.0:9092->9092/tcp             kafka_a
3b8ccf0b6bca   confluentinc/cp-enterprise-kafka:7.6.1   "/etc/confluent/dock…"   About a minute ago   Up About a minute                      9092/tcp, 0.0.0.0:9093->9093/tcp   kafka_b
3e731bd71869   confluentinc/cp-zookeeper:7.6.1          "/etc/confluent/dock…"   About a minute ago   Up About a minute                      2181/tcp, 2888/tcp, 3888/tcp       zookeeper_b
294ea50faa46   confluentinc/cp-zookeeper:7.6.1          "/etc/confluent/dock…"   About a minute ago   Up About a minute                      2181/tcp, 2888/tcp, 3888/tcp       zookeeper
```


### Produce some messages for the principal cluster

```bash
$ docker-compose  exec kafka_a kafka-console-producer --broker-list kafka_a:29092 --topic topic.topic.source                                                                                                     ‹system: ruby 2.6.10p210›

>This is a message
>That I might not want to write
>message 1
>message 2
>message 3
>message 4
>^C%       
```

Check the produced messages by using:

```bash
$ docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_a:29092 --topic topic.topic.source --from-beginning                                                                                ‹system: ruby 2.6.10p210›
This is a message
That I might not want to write
message 1
message 2
message 3
^CProcessed a total of 5 messages
```

### Create the replicator

```bash
$ bash scripts/create-replicator.sh                                                                                                                                                                               ‹system: ruby 2.6.10p210›
Creating a Replicator
HTTP/1.1 201 Created
Date: Tue, 14 May 2024 07:45:03 GMT
Location: http://localhost:8083/connectors/kfk-replicator
Content-Type: application/json
Content-Length: 1306
Server: Jetty(9.4.51.v20230217)

{"name":"kfk-replicator","config":{"connector.class":"io.confluent.connect.replicator.ReplicatorSourceConnector","dest.kafka.bootstrap.servers":"kafka_b:29094","dest.kafka.sasl.jaas.config":"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"kafka\" password=\"kafka\";","dest.kafka.sasl.mechanism":"PLAIN","dest.kafka.security.protocol":"SASL_PLAINTEXT","dest.topic.replication.factor":"1","src.kafka.bootstrap.servers":"kafka_a:29092","src.consumer.group.id":"connect-replicator","src.kafka.timestamps.topic.replication.factor":"1","confluent.topic.replication.factor":"1","producer.override.bootstrap.servers":"kafka_b:29094","producer.override.sasl.jaas.config":"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"kafka\" password=\"kafka\";","producer.override.sasl.mechanism":"PLAIN","producer.override.security.protocol":"SASL_PLAINTEXT","tasks.max":"2","offset.translator.tasks.max":"1","offset.translator.tasks.separate":"true","offset.translator.batch.period.ms":"10000","provenance.header.enable":"true","topic.whitelist":"topic-topic-source","key.converter":"io.confluent.connect.replicator.util.ByteArrayConverter","value.converter":"io.confluent.connect.replicator.util.ByteArrayConverter","name":"kfk-replicator"},"tasks":[],"type":"source"}%   
```

at this point data is moving to the secondary cluster:

```bash
$  docker exec kafka_b kafka-topics --bootstrap-server kafka_b:29093 --list                                                                                                                                       ‹system: ruby 2.6.10p210›
_confluent-command
topic-topic-source
```

#### Verify the messages in the secondary cluster

```bash
~/work/ps/disaster-recovery-playbook/replicator on  main! ⌚ 9:45:38
$ docker-compose exec kafka_b kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic topic.topic.source --from-beginning                                                                                ‹system: ruby 2.6.10p210›
This is a message
That I might not want to write
message 1
message 2
message 3
^CProcessed a total of 5 messages
```

At this point the reader can observe how the message, previously produced in the primary cluster are now also available in the secondary.

### Tear down

```bash
$ docker-compose down                                                                                                                                                                                             ‹system: ruby 2.6.10p210›
[+] Running 6/5
 ✔ Container kafka-connect     Removed                                                                                                                                                                                                 5.4s 
 ✔ Container kafka_b           Removed                                                                                                                                                                                                 0.8s 
 ✔ Container kafka_a           Removed                                                                                                                                                                                                 0.8s 
 ✔ Container zookeeper_b       Removed                                                                                                                                                                                                 0.5s 
 ✔ Container zookeeper         Removed                                                                                                                                                                                                 0.5s 
 ✔ Network replicator_default  Removed   
 ```

 ## Using a Router at the end of the pipeline

### Setup

```bash
$ ./up                                                                                                                                                                                                                             ‹system: ruby 2.6.10p210›
[+] Building 1.8s (7/7) FINISHED                                                                                                                                                                                                        docker:desktop-linux
 => [kafka-connect internal] load .dockerignore                                                                                                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                                                                                                                         0.0s
 => [kafka-connect internal] load build definition from Dockerfile                                                                                                                                                                                      0.0s
 => => transferring dockerfile: 450B                                                                                                                                                                                                                    0.0s
 => [kafka-connect internal] load metadata for docker.io/confluentinc/cp-kafka-connect:7.5.0                                                                                                                                                            1.8s
 => [kafka-connect stage-1 1/2] FROM docker.io/confluentinc/cp-kafka-connect:7.5.0@sha256:09356387a73723692aa0c7aa60eb259c1e7d57c74da2ac8ced768617613739ce                                                                                              0.0s
 => CACHED [kafka-connect install-connectors 2/2] RUN confluent-hub install --no-prompt confluentinc/kafka-connect-replicator:7.5.0                                                                                                                     0.0s
 => CACHED [kafka-connect stage-1 2/2] COPY --from=install-connectors /usr/share/confluent-hub-components/ /usr/share/confluent-hub-components/                                                                                                         0.0s
 => [kafka-connect] exporting to image                                                                                                                                                                                                                  0.0s
 => => exporting layers                                                                                                                                                                                                                                 0.0s
 => => writing image sha256:6feffd9df0c5ed8368ca6a0ce6b7e82c709a6ca91bd45e8bf3596ab72dd70d4d                                                                                                                                                            0.0s
 => => naming to docker.io/library/replicator-kafka-connect                                                                                                                                                                                             0.0s
[+] Running 6/6
 ✔ Network replicator_default  Created                                                                                                                                                                                                                  0.0s 
 ✔ Container zookeeper         Started                                                                                                                                                                                                                  0.0s 
 ✔ Container zookeeper_b       Started                                                                                                                                                                                                                  0.0s 
 ✔ Container kafka_a           Started                                                                                                                                                                                                                  0.0s 
 ✔ Container kafka_b           Started                                                                                                                                                                                                                  0.0s 
 ✔ Container kafka-connect     Started                                                                                                                                                                                                                  0.0s 
Example configuration:
-> docker-compose exec kafka kafka-console-producer --broker-list kafka:9093 --producer.config /etc/kafka/consumer.properties --topic test
-> docker-compose exec kafka kafka-console-consumer --bootstrap-server kafka:9093 --consumer.config /etc/kafka/consumer.properties --topic test --from-beginning
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
[2024-05-14 12:56:23,453] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 12:56:23,563] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 12:56:23,664] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 12:56:23,866] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 12:56:24,368] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 12:56:25,173] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)
[2024-05-14 12:56:26,378] WARN [AdminClient clientId=adminclient-1] Connection to node -1 (kafka_a/172.26.0.4:29092) could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)
Created topic __consumer_timestamps.
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic topic.topic.source.
WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
Created topic source.in.
```
### Produce some messages at source

```bash
$ docker-compose  exec kafka_a kafka-console-producer --broker-list kafka_a:29092 --topic topic.topic.source                                                                                                                       ‹system: ruby 2.6.10p210›

>1
>2
>3
>4
>5
>6
>^C%  
```

### Create an instance of the Replicator with the Routing transformation

```bash
$ bash scripts/create-replicator-with-routing.sh                                                                                                                                                                                   ‹system: ruby 2.6.10p210›
Creating a Replicator
HTTP/1.1 201 Created
Date: Tue, 14 May 2024 13:03:25 GMT
Location: http://localhost:8083/connectors/kfk-replicator
Content-Type: application/json
Content-Length: 1504
Server: Jetty(9.4.51.v20230217)

{"name":"kfk-replicator","config":{"connector.class":"io.confluent.connect.replicator.ReplicatorSourceConnector","dest.kafka.bootstrap.servers":"kafka_b:29094","dest.kafka.sasl.jaas.config":"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"kafka\" password=\"kafka\";","dest.kafka.sasl.mechanism":"PLAIN","dest.kafka.security.protocol":"SASL_PLAINTEXT","dest.topic.replication.factor":"1","src.kafka.bootstrap.servers":"kafka_a:29092","src.consumer.group.id":"connect-replicator","src.kafka.timestamps.topic.replication.factor":"1","confluent.topic.replication.factor":"1","producer.override.bootstrap.servers":"kafka_b:29094","producer.override.sasl.jaas.config":"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"kafka\" password=\"kafka\";","producer.override.sasl.mechanism":"PLAIN","producer.override.security.protocol":"SASL_PLAINTEXT","tasks.max":"2","offset.translator.tasks.max":"1","offset.translator.tasks.separate":"true","offset.translator.batch.period.ms":"10000","provenance.header.enable":"true","topic.whitelist":"topic.topic.source","key.converter":"io.confluent.connect.replicator.util.ByteArrayConverter","value.converter":"io.confluent.connect.replicator.util.ByteArrayConverter","transforms":"dropPrefix","transforms.dropPrefix.type":"org.apache.kafka.connect.transforms.RegexRouter","transforms.dropPrefix.regex":"topic.topic.(.*)","transforms.dropPrefix.replacement":"$1.in","name":"kfk-replicator"},"tasks":[],"type":"source"}%             
```

### Verify the messages in the target topic

```bash
$ docker-compose exec kafka_a kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic source.in --from-beginning                                                                                                          ‹system: ruby 2.6.10p210›
1
2
3
4
5
6
^CProcessed a total of 6 messages
```

