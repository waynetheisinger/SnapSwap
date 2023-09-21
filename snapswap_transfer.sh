#!/bin/bash

# Set error handling
set -e
set -o pipefail

# Packer
echo "Starting Packer build..."
packer build path_to_packer_template.json
echo "Packer build completed."

# Terraform
echo "Initializing Terraform..."
terraform init path_to_terraform_directory/
echo "Applying Terraform plan..."
terraform apply -auto-approve path_to_terraform_directory/
echo "Terraform apply completed."

# Ansible
echo "Starting Ansible playbook..."
ansible-playbook path_to_ansible_playbook.yml
echo "Ansible playbook completed."

echo "Snapshot transfer completed!"
