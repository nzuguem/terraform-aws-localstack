FROM gitpod/workspace-full

# Install Tools
RUN <<EOF
set -e

## Install TF
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - 
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" 
sudo apt-get install terraform --upgrade

### Install Terraform Local
pip install --no-cache-dir terraform-local

## Install AWS CLI
pip install --no-cache-dir awscli --upgrade
EOF