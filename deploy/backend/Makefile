export SUFFIX?=demo
export REGION?=us-east-1
export BUCKET_NAME?=kube-autoscaling-tfstate
BACKEND?=generated
OUTPUT_FILE?=$(BACKEND)/backend-output.json
YAML_SRC:=backend-resources.yaml

all: deploy

deploy: $(YAML_SRC)
	@mkdir -p $(BACKEND)
	aws cloudformation create-stack --stack-name $(SUFFIX) --region $(REGION) --template-body file://$(YAML_SRC) --parameters ParameterKey=Tag,ParameterValue=$(SUFFIX) ParameterKey=BucketName,ParameterValue=$(BUCKET_NAME)
	@echo "Waiting for cloud formation successful deployment"
	@aws cloudformation wait stack-create-complete --stack-name $(SUFFIX) --region $(REGION)
	@echo -n "{\"backend\":" > $(OUTPUT_FILE)
	@aws cloudformation describe-stacks --stack-name $(SUFFIX) --region $(REGION) --query 'Stacks[0]' >> $(OUTPUT_FILE)
	@echo -n "}" >> $(OUTPUT_FILE)
	@echo "\nOUTPUT FILE: $(OUTPUT_FILE)"

destroy:
	aws cloudformation delete-stack --stack-name $(SUFFIX) --region $(REGION)
	aws cloudformation wait stack-delete-complete --stack-name $(shell aws cloudformation describe-stacks --region $(REGION) --stack-name $(SUFFIX) --query 'Stacks[0].StackId' --output text) --region $(REGION)

