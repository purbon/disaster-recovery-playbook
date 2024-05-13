FROM fedora:41
ENV container docker

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/7.6/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install zookeeper and kafka
RUN yum install -y java-11-openjdk-devel
RUN yum install -y curl which
RUN yum install -y confluent-server confluent-security confluent-schema-registry

# 3. Configure Kafka and zookeeper for Kerberos 
COPY kafka.properties /etc/kafka/server.properties
COPY log4j.properties /etc/kafka/log4j.propertie
COPY kafka_server_jaas.conf /etc/kafka/kafka_server_jaas.conf
COPY alice.properties /etc/kafka/alice.properties
COPY bob.properties /etc/kafka/bob.properties

EXPOSE 9093

CMD kafka-server-start /etc/kafka/server.properties