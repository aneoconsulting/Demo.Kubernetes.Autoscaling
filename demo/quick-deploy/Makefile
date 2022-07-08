export DEMO_SUFFIX?=demo
export DEMO_REGION?=eu-west-3
export DEMO_PROFILE?=default
export DEMO_KUBERNETES_NAMESPACE?=demo
export KEDA_KUBERNETES_NAMESPACE?=default

CURRENT_DIR=$(shell pwd)
VPC_PARAMETERS_FILE?=$(CURRENT_DIR)/vpc/generated/vpc-output.json
EKS_PARAMETERS_FILE?=$(CURRENT_DIR)/eks/generated/eks-output.json
SQS_PARAMETERS_FILE?=$(CURRENT_DIR)/sqs/generated/sqs-output.json
METRICS_EXPORTER_PARAMETERS_FILE?=$(CURRENT_DIR)/metrics-exporter/generated/metrics-exporter-output.json

include envvars.sh

####################################
#             AWS VPC              #
####################################

deploy-vpc:
	$(MAKE) -C $(CURRENT_DIR)/vpc deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME)

destroy-vpc:
	$(MAKE) -C $(CURRENT_DIR)/vpc destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME)

clean-vpc:
	$(MAKE) -C $(CURRENT_DIR)/vpc clean

####################################
#            AWS ECR               #
####################################

deploy-ecr:
	$(MAKE) -C $(CURRENT_DIR)/ecr deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE)

destroy-ecr:
	$(MAKE) -C $(CURRENT_DIR)/ecr destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE)

clean-ecr:
	$(MAKE) -C $(CURRENT_DIR)/ecr clean

####################################
#             AWS EKS              #
####################################

deploy-eks:
	$(MAKE) -C $(CURRENT_DIR)/eks deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME) \
		VPC_PARAMETERS_FILE=$(VPC_PARAMETERS_FILE)

destroy-eks:
	$(MAKE) -C $(CURRENT_DIR)/eks destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME) \
		VPC_PARAMETERS_FILE=$(VPC_PARAMETERS_FILE)

clean-eks:
	$(MAKE) -C $(CURRENT_DIR)/eks clean

####################################
#       Kubernetes namespace       #
####################################

create-namespace:
	kubectl create namespace $(DEMO_KUBERNETES_NAMESPACE) || true
	kubectl create namespace $(KEDA_KUBERNETES_NAMESPACE) || true

delete-namespace:
	kubectl delete namespace $(DEMO_KUBERNETES_NAMESPACE) || true
	kubectl delete namespace $(KEDA_KUBERNETES_NAMESPACE) || true

####################################
#              KEDA                #
####################################

deploy-keda:
	$(MAKE) -C $(CURRENT_DIR)/keda deploy \
		EKS_PARAMETERS_FILE=$(EKS_PARAMETERS_FILE) \
		NAMESPACE=$(KEDA_KUBERNETES_NAMESPACE)

destroy-keda:
	$(MAKE) -C $(CURRENT_DIR)/keda destroy \
		EKS_PARAMETERS_FILE=$(EKS_PARAMETERS_FILE) \
		NAMESPACE=$(KEDA_KUBERNETES_NAMESPACE)

clean-keda:
	$(MAKE) -C $(CURRENT_DIR)/keda clean

####################################
#            AWS SQS               #
####################################

deploy-sqs:
	$(MAKE) -C $(CURRENT_DIR)/sqs deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE)

destroy-sqs:
	$(MAKE) -C $(CURRENT_DIR)/sqs destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		PROFILE=$(DEMO_PROFILE)

clean-sqs:
	$(MAKE) -C $(CURRENT_DIR)/sqs clean

####################################
#        Metrics exporter          #
####################################

deploy-metrics-exporter:
	$(MAKE) -C $(CURRENT_DIR)/metrics-exporter deploy \
		EKS_PARAMETERS_FILE=$(EKS_PARAMETERS_FILE) \
		NAMESPACE=$(DEMO_KUBERNETES_NAMESPACE)

destroy-metrics-exporter:
	$(MAKE) -C $(CURRENT_DIR)/metrics-exporter destroy \
		EKS_PARAMETERS_FILE=$(EKS_PARAMETERS_FILE) \
		NAMESPACE=$(DEMO_KUBERNETES_NAMESPACE)

clean-metrics-exporter:
	$(MAKE) -C $(CURRENT_DIR)/metrics-exporter clean

####################################
#           Application            #
####################################

deploy-application:
	$(MAKE) -C $(CURRENT_DIR)/application deploy \
		EKS_PARAMETERS_FILE=$(EKS_PARAMETERS_FILE) \
		SQS_PARAMETERS_FILE=$(SQS_PARAMETERS_FILE) \
		METRICS_EXPORTER_PARAMETERS_FILE=$(METRICS_EXPORTER_PARAMETERS_FILE) \
		NAMESPACE=$(DEMO_KUBERNETES_NAMESPACE)

destroy-application:
	$(MAKE) -C $(CURRENT_DIR)/application destroy \
		EKS_PARAMETERS_FILE=$(EKS_PARAMETERS_FILE) \
		SQS_PARAMETERS_FILE=$(SQS_PARAMETERS_FILE) \
		METRICS_EXPORTER_PARAMETERS_FILE=$(METRICS_EXPORTER_PARAMETERS_FILE) \
		NAMESPACE=$(DEMO_KUBERNETES_NAMESPACE)

clean-application:
	$(MAKE) -C $(CURRENT_DIR)/application clean

####################################
#               All                #
####################################

deploy-all: deploy-vpc deploy-sqs deploy-ecr deploy-eks create-namespace deploy-keda deploy-metrics-exporter deploy-application

destroy-all: destroy-application destroy-metrics-exporter destroy-keda delete-namespace destroy-eks destroy-ecr destroy-sqs destroy-vpc

clean-all: clean-application clean-metrics-exporter clean-keda clean-eks clean-ecr clean-sqs clean-vpc
