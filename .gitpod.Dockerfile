FROM gitpod/workspace-full

# Install TF
RUN <<EOF
set -e

sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - 
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" 
sudo apt-get install terraform

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