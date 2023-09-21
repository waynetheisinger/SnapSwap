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
    trap "cd ../; terraform destroy -auto-approve" ERR

    # Check for SRC_DIGITALOCEAN_TOKEN in environment or .env file
    load_env_var "SRC_DIGITALOCEAN_TOKEN"

    echo "Launching droplet and attaching volume..."
    cd createSnapshot/
    terraform init
    terraform apply -auto-approve
    echo "complete..."

    echo "Moving data from volume to droplet..."
    ansible-playbook ansible/movetodroplet/playbook.yml
    echo "complete..."

    # Get snapshot ID from Terraform output
    SNAPSHOT_ID=$(terraform output snapshot_id)
    echo "Snapshot ID: $SNAPSHOT_ID"

    # Provide user with instructions for the manual step
    echo "Snapshot has been created. Please go to the DigitalOcean Control Panel and:"
    echo "1. Navigate to Images -> Snapshots."
    echo "2. Select the snapshot and choose 'Change Owner' under 'More'."
    echo "3. Enter the destination team's email address and confirm the transfer."
    echo "After the snapshot transfer has been accepted, run this script with 'finalize'."

    # clean up
    terraform destroy -auto-approve
    cd ..

    echo "Snapshot creation and initial transfer complete!"
}

# Function to finalize the process after snapshot transfer
finalize_transfer() {
    trap "cd ../; terraform destroy -auto-approve" ERR

    # Check for DST_DIGITALOCEAN_TOKEN in environment or .env file
    load_env_var "DST_DIGITALOCEAN_TOKEN"

    cd deploySnapshot/
    echo "Launching droplet..."
    terraform init
    terraform apply -auto-approve
    echo "Complete..."
    cd ..

    echo "Moving data from droplet to volume..."
    ansible-playbook ansible/movetovolumen/playbook.yml
    echo "Complete..."

    cd snapshotVolume/
    echo "Creating snapshot volume..."
    terraform init
    terraform apply -auto-approve
    echo "Complete..."

    echo "Cleaning up..."
    # clean up
    terraform destroy -auto-approve
    cd ..

    echo "Snapshot transfer finalized and resources cleaned up!"
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
