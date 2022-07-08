CURRENT_DIR=$(shell pwd)
GENERATED_DIR=$(CURRENT_DIR)/generated
PARAMETERS_FILE?=parameters.tfvars
STATE_FILE=$(GENERATED_DIR)/application-terraform.tfstate
OUTPUT_FILE=$(GENERATED_DIR)/application-output.json

export TF_DATA_DIR?=$(GENERATED_DIR)
export NAMESPACE?=demo
export SUFFIX?=demo
export REGION?=eu-west-3
export PROFILE?=default
export EKS_PARAMETERS_FILE?=$(CURRENT_DIR)/../eks/generated/eks-output.json
export SQS_PARAMETERS_FILE?=$(CURRENT_DIR)/../sqs/generated/sqs-output.json
export METRICS_EXPORTER_PARAMETERS_FILE?=$(CURRENT_DIR)/../metrics-exporter/generated/metrics-exporter-output.json

.PHONY: apply destroy

all: init apply output
deploy: init apply output

init:
	mkdir -p $(GENERATED_DIR)
	terraform init

apply:
	terraform apply \
		-var-file $(PARAMETERS_FILE) \
		-var-file $(EKS_PARAMETERS_FILE) \
		-var-file $(SQS_PARAMETERS_FILE) \
		-var-file $(METRICS_EXPORTER_PARAMETERS_FILE) \
		-var 'namespace=$(NAMESPACE)' \
		-var 'region=$(REGION)' \
		-var 'suffix=$(SUFFIX)' \
		-var 'profile=$(PROFILE)' \
		-state $(STATE_FILE) \
		-auto-approve

output:
	@echo -n "{\"application\":" > $(OUTPUT_FILE)
	@terraform output -state=$(STATE_FILE) -json application >> $(OUTPUT_FILE)
	@echo -n "}" >> $(OUTPUT_FILE)
	@echo "\nOUTPUT FILE: $(OUTPUT_FILE)"

destroy:
	terraform destroy \
		-var-file $(PARAMETERS_FILE) \
		-var-file $(EKS_PARAMETERS_FILE) \
		-var-file $(SQS_PARAMETERS_FILE) \
		-var-file $(METRICS_EXPORTER_PARAMETERS_FILE) \
		-var 'namespace=$(NAMESPACE)' \
		-var 'region=$(REGION)' \
		-var 'suffix=$(SUFFIX)' \
		-var 'profile=$(PROFILE)' \
		-state $(STATE_FILE) \
		-auto-approve

clean:
	rm -rf $(TF_DATA_DIR) .terraform.lock.hcl .terraform

docs:
	terraform-docs markdown table --output-file parameters.md --output-mode inject $(CURRENT_DIR)
