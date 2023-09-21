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

# Function to handle snapshot creation and transfer initiation
create_snapshot() {
    # Check for SRC_DIGITALOCEAN_TOKEN in environment or .env file
    load_env_var "SRC_DIGITALOCEAN_TOKEN"

    echo "Starting Packer build..."
    packer build packer/
    echo "Packer build completed."

    # Provide user with instructions for the manual step
    echo "Snapshot has been created. Please go to the DigitalOcean Control Panel and:"
    echo "1. Navigate to Images -> Snapshots."
    echo "2. Select the snapshot and choose 'Change Owner' under 'More'."
    echo "3. Enter the destination team's email address and confirm the transfer."
    echo "After the snapshot transfer has been accepted, run this script with 'finalize'."
}

# Function to finalize the process after snapshot transfer
finalize_transfer() {
    # Check for DST_DIGITALOCEAN_TOKEN in environment or .env file
    load_env_var "DST_DIGITALOCEAN_TOKEN"

    echo "Initializing Terraform..."
    terraform init terraform/
    echo "Applying Terraform plan..."
    terraform apply -auto-approve terraform/
    echo "Terraform apply completed."

    echo "Starting Ansible playbook..."
    ansible-playbook ansible/playbook.yml
    echo "Ansible playbook completed."

    echo "Snapshot transfer process finalized!"
}

# Check command-line argument
case "$1" in
    create-snapshot)
        create_snapshot
        ;;
    finalize)
        finalize_transfer
        ;;
    *)
        echo "Usage: $0 {create-snapshot|finalize}"
        exit 1
        ;;
esac
