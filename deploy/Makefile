export DEMO_SUFFIX?=demo
export DEMO_REGION?=us-east-1
export DEMO_PROFILE?=default
export DEMO_BUCKET_NAME?=kube-autoscaling-tfstate
export DEMO_KUBERNETES_NAMESPACE?=demo
export DEMO_CLUSTER_NAME?=demo-cluster
export TFSTATE_BUCKET_NAME=$(DEMO_BUCKET_NAME)-$(DEMO_SUFFIX)

CURRENT_DIR=$(shell pwd)

####################################
# KSM and S3 buckets for TF states #
####################################

deploy-backend:
	$(MAKE) -C $(CURRENT_DIR)/backend deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME)

destroy-backend:
	$(MAKE) -C $(CURRENT_DIR)/backend destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME)

clean-backend:
	$(MAKE) -C $(CURRENT_DIR)/backend clean

####################################
#               VPC                #
####################################

deploy-vpc:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/vpc deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME)

destroy-vpc:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/vpc destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME)

clean-vpc:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/vpc clean

####################################
#               ECR                #
####################################

deploy-ecr:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/ecr deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME)

destroy-ecr:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/ecr destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME)

clean-ecr:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/ecr clean

####################################
#               EKS                #
####################################

deploy-eks:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/eks deploy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME)

destroy-eks:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/eks destroy \
		SUFFIX=$(DEMO_SUFFIX) \
		REGION=$(DEMO_REGION) \
		BUCKET_NAME=$(DEMO_BUCKET_NAME) \
		CLUSTER_NAME=$(DEMO_CLUSTER_NAME)

clean-eks:
	$(MAKE) -C $(CURRENT_DIR)/infrastructure/eks clean

####################################
#               All                #
####################################

deploy-all: deploy-backend deploy-vpc deploy-ecr deploy-eks

destroy-all: destroy-eks destroy-ecr destroy-vpc destroy-backend

clean-all: clean-eks clean-ecr clean-vpc clean-backend

