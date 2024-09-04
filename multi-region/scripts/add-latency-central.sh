#!/usr/bin/env bash


export DOCKER_NETWORK=multi-region_n1
export ZOOKEEPER_WEST_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' zookeeper-west)
export ZOOKEEPER_EAST_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' zookeeper-east)
export KAFKA_WEST_1_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' broker-west-1)
export KAFKA_WEST_2_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' broker-west-2)
export KAFKA_EAST_3_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' broker-east-3)
export KAFKA_EAST_4_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' broker-east-4)
export SUBNET=$(docker inspect multi-region_n1 -f '{{(index .IPAM.Config 0).Subnet}}')


echo -e "\n==> Configuring central as a medium latency link (50ms)"
docker compose exec -u0 zookeeper-central tc qdisc add dev eth0 root handle 1: prio > /dev/null
docker compose exec -u0 zookeeper-central tc qdisc add dev eth0 parent 1:1 handle 10: sfq > /dev/null
docker compose exec -u0 zookeeper-central tc qdisc add dev eth0 parent 1:2 handle 20: sfq > /dev/null
docker compose exec -u0 zookeeper-central tc qdisc add dev eth0 parent 1:3 handle 30: netem delay 50ms 10ms 20.00 > /dev/null
docker compose exec -u0 zookeeper-central tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst $SUBNET flowid 1:3 > /dev/null