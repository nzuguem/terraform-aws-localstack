default: help

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

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
	@$(MAKE) tf-init
	@$(MAKE) tflint-init
	@$(MAKE) pre-commit-install
	@$(MAKE) tf-apply

clean-env: ## Stop Localstack
	@docker compose -f compose.localstack.yml down

tf-create-ws-prod: ## Create prod workspace
	@terraform workspace new 'prod'

tf-apply-prod: ## Apply resources for PROD
	@terraform workspace select  -or-create=true 'prod'
	@terraform apply -auto-approve -var-file $$(terraform workspace show).tfvars

switch-tofu: ## Switch To OpenTofu Context
	@rm -rf .terraform/ || true
	@rm .terraform.lock.hcl || true
	@git switch tofu
	@$(MAKE) clean-env
	@$(MAKE) setup-env