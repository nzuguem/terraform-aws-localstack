FROM gitpod/workspace-full

# Install Tools
RUN <<EOF


set -e

brew update
pip install --upgrade pip

## Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

## install OpenTofu
brew install opentofu

## Install Terraform Local
pip install --no-cache-dir terraform-local --upgrade

## Install TF Tools
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
brew install terragrunt

## Install AWS CLI
pip install --no-cache-dir awscli --upgrade
## Install AWS CLI Local
pip install --no-cache-dir awscli-local --upgrade

## Install pre-commit
pip install --no-cache-dir pre-commit --upgrade

EOF