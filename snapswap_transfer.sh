#!/bin/bash

# Set error handling
set -e
set -o pipefail

# Function to load and check a specific environment variable from .env file
load_env_var() {
    local var_name="$1"
    if [[ -z "${!var_name}" ]]; then
        if [[ -f ".env" ]]; then
            source .env
            if [[ -z "${!var_name}" ]]; then
                echo "Error: $var_name is not set in the .env file."
                exit 1
            fi
        else
            echo "Error: .env file not found and $var_name not set in environment."
            exit 1
        fi
    fi
}

# Check for SRC_DIGITALOCEAN_TOKEN and DST_DIGITALOCEAN_TOKEN in environment or .env file
load_env_var "SRC_DIGITALOCEAN_TOKEN"
load_env_var "DST_DIGITALOCEAN_TOKEN"

# Packer (Assuming Packer uses SRC_DIGITALOCEAN_TOKEN)
echo "Starting Packer build..."
packer build path_to_packer_template.json
echo "Packer build completed."

# Terraform (You might need to adjust how Terraform uses SRC and DST tokens)
echo "Initializing Terraform..."
terraform init path_to_terraform_directory/
echo "Applying Terraform plan..."
terraform apply -auto-approve path_to_terraform_directory/
echo "Terraform apply completed."

# Ansible (Ensure Ansible knows which token to use where in the playbook)
echo "Starting Ansible playbook..."
ansible-playbook path_to_ansible_playbook.yml
echo "Ansible playbook completed."

echo "Snapshot transfer completed!"
