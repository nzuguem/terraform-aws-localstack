FROM gitpod/workspace-full

# Install TF
RUN <<EOF
set -e

brew update

## Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

## Install Terraform Local
pip install --no-cache-dir terraform-local --upgrade

## Install TF Tools
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

EOF

# Install AWS CLI
RUN <<EOF

pip install --no-cache-dir awscli --upgrade
## Install AWS CLI Local
pip install --no-cache-dir awscli-local --upgrade

EOF

# Install pre-commit
RUN <<EOF

pip install --no-cache-dir pre-commit --upgrade

EOF