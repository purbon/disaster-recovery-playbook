echo -e "\n\n==> Produce: Multi-region ASync Replication (topic: multi-region-async-op-under-min-isr) \n"

docker compose exec broker-west-1 kafka-producer-perf-test --topic multi-region-async-op-under-min-isr \
    --num-records 5000 \
    --record-size 5000 \
    --throughput -1 \
    --producer-props \
        acks=all \
        bootstrap.servers=broker-west-1:19091,broker-east-3:19093 \
        compression.type=none \
        batch.size=8196