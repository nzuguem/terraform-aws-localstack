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

create-kms-key: ## Create KMS Key
	@aws kms create-key \
	--region eu-west-3 \
	--endpoint http://localhost:4566

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

tf-init: ## Tofu Init phase
	@tofu init

tf-apply: ## Tofu Apply phase
	@tofu apply -auto-approve

tf-destroy: ## Tofu Destroy phase
	@tofu destroy -auto-approve

tf-format: ## Format TF Configuration File
	@tofu fmt

tf-validate: ## Validate TF Configuration File
	@tofu validate

pre-commit-install: ## Install pre-commit Git Hooks
	@pre-commit install

tflint-init: ## Install TFLint Plugins
	@tflint --init

setup-env: ## Setup Environment
	@$(MAKE) -s start-localstack
	@$(MAKE) -s setup-tf-backend
	@$(MAKE) -s create-test-secret
	@$(MAKE) -s tf-init
	@$(MAKE) -s tflint-init
	@$(MAKE) -s pre-commit-install
	@$(MAKE) -s tf-apply

clean-env: ## Stop Localstack
	@docker compose -f compose.localstack.yml down

switch-terraform: ## Switch To Terrform Context
	@rm -rf .terraform/ || true
	@rm .terraform.lock.hcl || true
	@git switch main
	@$(MAKE) clean-env
	@$(MAKE) setup-env