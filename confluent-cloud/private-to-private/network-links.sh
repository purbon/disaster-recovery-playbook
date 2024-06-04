#!/usr/bin/env bash



#The target Confluent Cloud Network contains:
#
#A Network Link Service
#
#A Network Link Service contains a list of network ID(s) and/or environment ID(s) that are allowed to establish Network Links to the target network.
#
#A Network Link Service can be updated with additional, different, or fewer, environment ID(s) and network ID(s) to change the allowed network topologies. 
#If an environment or network id is removed from the list, all network links from that environment or network are terminated. A terminated Network Link will cause its Network Link Endpoint to enter the disconnected state and its cluster link(s) to stop replicating data.
#
#Network Link Service Association
#
#A Network Link Service Association contains a list of incoming Network Link Endpoints associated with a Network Link Service.
#
#The origin Confluent Cloud Network contains:
#
#A Network Link Endpoint
#
#A Network Link Endpoint refers to one specific Network Link Service. It must be created after the Network Link Service.
#
#When the Network Link Endpoint’s status changes to READY, the Network Link has been successfully established.

## create the network link service


source cluster-link-rc.sh

confluent environment use $primary_environment

### origin cloud network (eu-west-1)

confluent network link service create dr-link-service \
  --network n-jvxyww \
  --description "disaster recovery network link service" \
  --accepted-environments env-m25yq1

#+-----------------------+----------------------------------------+
#| ID                    | nls-61er9o                             |
#| Name                  | dr-link-service                        |
#| Network               | n-jvxyww                               |
#| Environment           | env-m25yq1                             |
#| Description           | disaster recovery network link service |
#| Accepted Environments | env-m25yq1                             |
#| Phase                 | READY                                  |
#+-----------------------+----------------------------------------+

confluent network link service update nls-61er9o \
  --description "disaster recovery network link service" \
  --accepted-environments env-m25yq1 \
  --accepted-networks n-jvxyww,n-jq43wy


confluent network link service  list                                                                                                                                                                                                                                   ‹system: ruby 2.6.10p210›
#      ID     |      Name       | Network  |          Description           | Accepted Environments | Accepted Networks | Phase  
#-------------+-----------------+----------+--------------------------------+-----------------------+-------------------+--------
#  nls-61er9o | dr-link-service | n-jvxyww | disaster recovery network link | env-m25yq1            |                   | READY  
 #            |                 |          | service                        |                       |                   |        

  ### target cloud network (eu-central-1)

  confluent network link endpoint create dr-link-endpoint \
  --network n-jq43wy \
  --description "disaster recovery network link service" \
  --network-link-service nls-61er9o