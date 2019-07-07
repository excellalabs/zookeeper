Apache Zookeeper
===================

This repository contains pipeline and infrastructure code for deploying Zookeeper
services for Excella Stream Processing Platform.

## What is Zookeeper
Zookeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications initially usually skimp on them, which make them brittle in the presence of change and difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications are deployed.

Zookeeper aims at distilling the essence of these different services into a very simple interface to a centralized coordination service. The service itself is distributed and highly reliable. Consensus, group management, and presence protocols will be implemented by the service so that the applications do not need to implement them on their own. Application specific uses of these will consist of a mixture of specific components of Zookeeper and application specific conventions.

## Connection Url: 
```
10.100.1.100:2181,10.100.2.100:2181,10.100.3.100:2181
```
## How to use it

1. Download and install [Confluent Platform](https://www.confluent.io/download/)
2. Some useful command:
    ```sh
    export zk=10.100.1.100:2181,10.100.2.100:2181,10.100.3.100:2181
    
    # get list of items
    $ zookeeper-shell $zk <<< "ls /"

    # get list of kafka brokers
    $ zookeeper-shell $zk <<< "ls /brokers/ids"

    # get a broker detail
    $ zookeeper-shell $zk <<< "get /brokers/ids/{id}"
    ```
## Run in locally
First, create a docker network named `xsp-network`
```sh
$ docker network create xsp-network
```
Now run the docker compose:
```sh
$ docker-compose up
```

## Tech Stack
- AWS
  - EC2 / ASG
  - EBS
  - ENI - Elastic Network Interface
  - Cloudformation
  - AMI
- Chef
- Packer
- Jenkins
