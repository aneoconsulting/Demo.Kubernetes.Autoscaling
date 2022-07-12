# Demo for Autoscaling in Kubernetes


## How to deploy

The documentation on how to deploy this demo can be found [here](./deployment/README.md)


## How to populate SQS queue

This repository provides a client that put and delete messages in an SQS queue.

The first way to use it is to install dotnet and run the application such as:

```
cd client/

dotnet run -- -q myQueue -r us-east-3
```


To find more informations on how to use the client can be found by running the following command:


```
dotnet run -- -h
```


The second possibility is to run the docker image built in this repository:

```
docker run --rm -v ${HOME}/.aws/credentials:/root/.aws/credentials -it dockerhubaneo/demo_kas_client:0.0.1-SNAPSHOT.20.01cc4e9 -q myQueue -r us-east-3
```
