# Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
    - [Software](#software)
    - [AWS credentials](#aws-credentials)
- [Set environment variables](#set-environment-variables)
- [All-in-one deploy](all-in-one-deploy)
- [Deploy infrastructure](#deploy-infrastructure)
    - [AWS VPC](#aws-vpc)
    - [AWS ECR](#aws-ecr)
    - [AWS SQS](#aws-sqs)
    - [AWS EKS](#aws-eks)
    - [Create Kubernetes namespace](#create-kubernetes-namespace)
    - [KEDA](#keda)
    - [Metrics exporter](#metrics-exporter)
    - [Application](#application)
- [Clean-up](#clean-up)

# Introduction

Hereafter, You have instructions to deploy infrastructure on AWS cloud.

The infrastructure is composed of:

* AWS VPC
* AWS ECR for docker images
* AWS SQS
* AWS EKS
* [KEDA](https://keda.sh/)
* Metrics exporter
* Application

# Prerequisites

## Software

The following software or tool should be installed upon your local Linux machine or VM from which you deploy the
infrastructure:

* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) version 2
* [Docker](https://docs.docker.com/engine/install/)
* [GNU make](https://www.gnu.org/software/make/)
* [JQ](https://stedolan.github.io/jq/download/)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) v1.23.6
* [Helm](https://helm.sh/docs/intro/install/)
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) version 1.0.9 and later

## AWS credentials

You must have credentials to be able to create AWS resources. You must create and provide
your [AWS programmatic access keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)
in your environment as follows:

```bash
mkdir -p ~/.aws
cat <<EOF | tee ~/.aws/credentials
[default]
aws_access_key_id = <ACCESS_KEY_ID>
aws_secret_access_key = <SECRET_ACCESS_KEY>
EOF
```

You can check connectivity to AWS using the following command:

```bash
aws sts get-caller-identity
```

the output of this command should be as follows:

```bash
{
    "UserId": "<USER_ID>",
    "Account": "<ACCOUNT_ID>",
    "Arn": "arn:aws:iam::<ACCOUNT_ID>:user/<USERNAME>"
}
```

# Set environment variables

From the **root** of the repository, position yourself in directory `demo/quick-deploy`.

```bash
cd demo/quick-deploy
```

You need to set a list of environment variables [envvars.sh](envvars.sh) :

```bash
source envvars.sh
```

**or:**

```bash
export DEMO_PROFILE=default
export DEMO_REGION=eu-west-3
export DEMO_SUFFIX=demo
export DEMO_KUBERNETES_NAMESPACE=demo
export KEDA_KUBERNETES_NAMESPACE=default
```

where:

- `DEMO_PROFILE`: defines your AWS profile which has credentials to deploy in AWS Cloud
- `DEMO_REGION`: presents the region where all resources will be created
- `DEMO_SUFFIX`: will be used as suffix to the name of all resources
- `DEMO_KUBERNETES_NAMESPACE`: is the namespace in Kubernetes for Demo
- `KEDA_KUBERNETES_NAMESPACE`: is the namespace in Kubernetes for [KEDA](https://keda.sh/)

**Warning:** `DEMO_SUFFIX` must be *UNIQUE* to allow resources to have unique name in AWS

# All-in-one deploy

All commands described hereafter can be executed with one command. To deploy infrastructure and Demo application in
all-in-one command, You execute:

```bash
make deploy-all
```

# Deploy infrastructure

## AWS VPC

You need to create an AWS Virtual Private Cloud (VPC) that provides an isolated virtual network environment. The
parameters of this VPC are in [vpc/parameters.tfvars](vpc/parameters.tfvars).

Execute the following command to create the VPC:

```bash
make deploy-vpc
```

The VPC deployment generates an output file `vpc/generated/vpc-output.json` which contains information about the VPC.

## AWS ECR

You need to create an AWS Elastic Container Registry (ECR) and push the container images needed for Kubernetes and
Demo [ecr/parameters.tfvars](ecr/parameters.tfvars).

Execute the following command to create the ECR and push the list of container images:

```bash
make deploy-ecr
```

The list of created ECR repositories are in `ecr/generated/ecr-output.json`.

## AWS SQS

You need to create an AWS Simple Queue Service (SQS) for Demo [sqs/parameters.tfvars](sqs/parameters.tfvars).

Execute the following command to create the SQS:

```bash
make deploy-sqs
```

The list of created SQS information are in `sqs/generated/sqs-output.json`.

## AWS EKS

You need to create an AWS Elastic Kubernetes Service (EKS). The parameters of EKS to be created are defined
in [eks/parameters.tfvars](eks/parameters.tfvars).

Execute the following command to create the EKS:

```bash
make deploy-eks
```

**or:**

```bash
make deploy-eks VPC_PARAMETERS_FILE=<path-to-vpc-parameters>
```

where:

- `<path-to-vpc-parameters>` is the **absolute** path to file `vpc/generated/vpc-output.json` containing the information
  about the VPC previously created.

The EKS deployment generates an output file `eks/generated/eks-output.json`.

## Create Kubernetes namespace

After the EKS deployment, You create a Kubernetes namespaces for Demo with the name set in the environment
variable`DEMO_KUBERNETES_NAMESPACE` and for KEDA with the name set in the environment
variable`KEDA_KUBERNETES_NAMESPACE`:

```bash
make create-namespace
```

## KEDA

The parameters of KEDA are defined in [keda/parameters.tfvars](keda/parameters.tfvars).

Execute the following command to install KEDA:

```bash
make deploy-keda
```

The Keda deployment generates an output file `keda/generated/keda-output.json`.

**NOTE:** Please note that KEDA must be deployed only ONCE on the same Kubernetes cluster.

## Metrics exporter

The parameters of metrics exporter are defined
in [metrics-exporter/parameters.tfvars](metrics-exporter/parameters.tfvars).

Execute the following command to install the metrics exporter:

```bash
make deploy-metrics-exporter
```

The metrics exporter deployment generates an output file `metrics-exporter/generated/metrics-exporter-output.json`.

## Application

The parameters of application are defined in [application/parameters.tfvars](application/parameters.tfvars).

Execute the following command to install the application:

```bash
make deploy-application
```

The application deployment generates an output file `application/generated/application-output.json`.

# Clean-up

To delete all resources created in AWS, You can execute the following all-in-one command:

```bash
make destroy-all
```

**or:** execute the following commands in this order:

```bash
make destroy-application
make destroy-metrics-exporter 
make destroy-keda
make destroy-eks 
make destroy-sqs
make destroy-ecr
make destroy-vpc 
```

To clean up and delete all generated files, You execute:

```bash
make clean-all
```

**or:**

```bash
make clean-application
make clean-metrics-exporter
make clean-keda
make clean-eks 
make clean-ecr
make clean-sqs
make clean-vpc 
```


