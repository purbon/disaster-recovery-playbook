 export CLASSPATH=/usr/share/confluent-hub-components/confluentinc-kafka-connect-replicator/lib/*
 docker exec kafka-connect kafka-console-consumer --topic __consumer_timestamps --bootstrap-server kafka:9093 \
    --property print.key=true --property key.deserializer=io.confluent.connect.replicator.offsets.GroupTopicPartitionDeserializer \
    --property value.deserializer=io.confluent.connect.replicator.offsets.TimestampAndDeltaDeserializer --from-beginning


     
docker exec kafka /opt/kafka/bin/kafka-console-consumer.sh \
   --topic topic-topic-source --bootstrap-server kafka:9093 --from-beginning --group testing-group

docker exec kafka-connect kafka-console-consumer \
   --property  interceptor.classes=io.confluent.connect.replicator.offsets.ConsumerTimestampsInterceptor \
   --topic topic-topic-source --bootstrap-server kafka:9093 --from-beginning --group testing-group


docker exec kafka /opt/kafka/bin/kafka-console-consumer.sh \
   --formatter "kafka.coordinator.group.GroupMetadataManager\$OffsetsMessageFormatter" \
   --bootstrap-server kafka:9093 --topic __consumer_offsets --from-beginning

   __consumer_offsets



docker exec kafka /opt/kafka/bin/kafka-console-consumer.sh --consumer.config=/opt/kafka/consumer-ccloud.properties \
   --formatter "kafka.coordinator.group.GroupMetadataManager\$OffsetsMessageFormatter" \
   --bootstrap-server  pkc-75m1o.europe-west3.gcp.confluent.cloud:9092 --topic __consumer_offsets --from-beginning

docker exec kafka /opt/kafka/bin/kafka-console-consumer.sh --consumer.config=/opt/kafka/consumer-ccloud.properties \
   --bootstrap-server  pkc-75m1o.europe-west3.gcp.confluent.cloud:9092 --topic topic-topic-source --from-beginning


docker exec kafka /opt/kafka/bin/kafka-consumer-groups.sh --command-config=/opt/kafka/consumer-ccloud.properties \
   --bootstrap-server  pkc-75m1o.europe-west3.gcp.confluent.cloud:9092 --list

   docker exec kafka /opt/kafka/bin/kafka-topics.sh --command-config=/opt/kafka/consumer-ccloud.properties \
   --bootstrap-server  pkc-75m1o.europe-west3.gcp.confluent.cloud:9092 --list



docker exec kafka /opt/kafka/bin/kafka-console-consumer.sh --consumer.config=/opt/kafka/consumer-ccloud.properties \
   --bootstrap-server  pkc-75m1o.europe-west3.gcp.confluent.cloud:9092 --topic topic-topic-source --group testing-group