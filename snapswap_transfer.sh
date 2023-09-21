#!/bin/bash

# Set error handling
set -e
set -o pipefail

# Check for DIGITALOCEAN_TOKEN in environment
if [[ -z "${DIGITALOCEAN_TOKEN}" ]]; then
    echo "DIGITALOCEAN_TOKEN is not set in the environment."

    # Check for .env file and load it
    if [[ -f ".env" ]]; then
        echo "Loading .env file..."
        source .env

        # Double check if the .env file actually had DIGITALOCEAN_TOKEN set
        if [[ -z "${DIGITALOCEAN_TOKEN}" ]]; then
            echo "Error: DIGITALOCEAN_TOKEN is not set in the .env file."
            exit 1
        fi
    else
        echo "Error: .env file not found and DIGITALOCEAN_TOKEN not set in environment."
        exit 1
    fi
fi

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
