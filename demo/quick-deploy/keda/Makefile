CURRENT_DIR=$(shell pwd)
GENERATED_DIR=$(CURRENT_DIR)/generated
PARAMETERS_FILE?=parameters.tfvars
STATE_FILE=$(GENERATED_DIR)/keda-terraform.tfstate
OUTPUT_FILE=$(GENERATED_DIR)/keda-output.json

export TF_DATA_DIR?=$(GENERATED_DIR)
export NAMESPACE?=default
export SUFFIX?=demo
export REGION?=eu-west-3
export PROFILE?=default
export EKS_PARAMETERS_FILE?=$(CURRENT_DIR)/../eks/generated/eks-output.json

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
		-var 'namespace=$(NAMESPACE)' \
		-var 'region=$(REGION)' \
		-var 'profile=$(PROFILE)' \
		-state $(STATE_FILE) \
		-auto-approve

output:
	@echo -n "{\"keda\":" > $(OUTPUT_FILE)
	@terraform output -state=$(STATE_FILE) -json keda >> $(OUTPUT_FILE)
	@echo -n "}" >> $(OUTPUT_FILE)
	@echo "\nOUTPUT FILE: $(OUTPUT_FILE)"

destroy:
	terraform destroy \
		-var-file $(PARAMETERS_FILE) \
		-var-file $(EKS_PARAMETERS_FILE) \
		-var 'namespace=$(NAMESPACE)' \
		-var 'region=$(REGION)' \
		-var 'profile=$(PROFILE)' \
		-state $(STATE_FILE) \
		-auto-approve

clean:
	rm -rf $(TF_DATA_DIR) .terraform.lock.hcl .terraform

docs:
	terraform-docs markdown table --output-file parameters.md --output-mode inject $(CURRENT_DIR)
