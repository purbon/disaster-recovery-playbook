docker-compose  exec kafka_b kafka-console-producer --broker-list kafka_b:29093 --topic topic-topic-source 

docker-compose exec kafka_b kafka-console-consumer  --bootstrap-server kafka_b:29093 --topic topic-topic-source --from-beginning 