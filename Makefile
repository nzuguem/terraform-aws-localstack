default: help

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

create-s3-tf-backend: ## Create Bucket S3 for TF Remote Backend
	@aws s3 mb s3://terraform-state \
	--region eu-west-3 \
	--endpoint http://localhost:4566 > /dev/null 2>&1

create-test-secret: ## Create Test Secret
	@aws secretsmanager create-secret \
    --name Test \
    --secret-string "{\"user\":\"gitpod\",\"password\":\"gitpod\"}" \
	--region eu-west-3 \
	--endpoint http://localhost:4566 > /dev/null 2>&1

create-dynamodb-tf-state-locking: ## Create DynamoDB Table for TF State Locking
	@aws dynamodb create-table \
    --table-name terraform-state \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --tags Key=ManagedBy,Value=Terraform \
	--region eu-west-3 \
	--endpoint http://localhost:4566 > /dev/null 2>&1

setup-tf-backend: ## Setup TF Remote Backend (S3 Bucket and DynamoDB Table)
	@$(MAKE) -s create-s3-tf-backend
	@$(MAKE) -s create-dynamodb-tf-state-locking

start-localstack: ## Start Localstack
	@docker compose -f compose.localstack.yml up -d --wait

tf-init: ## Terraform Init phase
	@terraform init

tf-apply: ## Terraform Apply phase
	@terraform apply -auto-approve

tf-destroy: ## Terraform Destroy phase
	@terraform destroy -auto-approve

tf-format: ## Format TF Configuration File
	@terraform fmt

tf-validate: ## Validate TF Configuration File
	@terraform validate

pre-commit-install: ## Install pre-commit Git Hooks
	@pre-commit install

tflint-init: ## Install TFLint Plugins
	@tflint --init

setup-env: ## Setup Environment
	@$(MAKE) start-localstack
	@$(MAKE) setup-tf-backend
	@$(MAKE) create-test-secret
	@$(MAKE) tf-init
	@$(MAKE) tflint-init
	@$(MAKE) pre-commit-install
	@$(MAKE) tf-apply

clean-env: ## Stop Localstack
	@docker compose -f compose.localstack.yml down

tf-create-ws-prod: ## Create prod workspace
	@terraform workspace new 'prod'

tf-apply-prod: ## Apply resources for PROD
	@terraform workspace select 'prod' -or-create
	@terraform apply -auto-approve -var-file $$(terraform workspace show).tfvars

switch-tofu: ## Switch To OpenTofu Context
	@git switch tofu
	@$(MAKE) clean-env
	@$(MAKE) setup-env