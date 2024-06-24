FROM confluentinc/cp-kafka-connect:7.5.0 AS install-connectors

ENV CONNECT_PLUGIN_PATH: "/usr/share/java,/usr/share/confluent-hub-components"
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-replicator:7.5.0 


FROM confluentinc/cp-enterprise-replicator:7.5.0

COPY --from=install-connectors /usr/share/confluent-hub-components/ /usr/share/confluent-hub-components/