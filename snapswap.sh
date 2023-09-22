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
    load_env_var "VOLUME_SNAPSHOT_NAME_REGEX"
    load_env_var "SRC_REGION"
    load_env_var "SRC_VOLUME_SIZE"

    echo "Launching droplet and attaching volume..."
    cd createDroplet/
    terraform init
    terraform apply -auto-approve \
    -var do_token="$SRC_DIGITALOCEAN_TOKEN" \
    -var volume_snapshot_name_regex="VOLUME_SNAPSHOT_NAME_REGEX" \
    -var src_region="$SRC_REGION" \
    -var src_volume_size="$SRC_VOLUME_SIZE"
    echo "complete..."

    # Get details from Terraform output
    DROPLET_NAME=$(terraform output droplet_name)
    VOLUME_NAME=$(terraform output volume_name)

    # Provide user with the details
    echo "Created Droplet Name: $DROPLET_NAME"
    echo "Created Volume Name: $VOLUME_NAME"
    echo "Continuing..."

    echo "Moving data from volume to droplet..."
    ansible-playbook -i ansible/main.ini ansible/copyToDroplet.yml
    echo "complete..."

    # create the snapshot
    terraform apply -auto-approve \
    -var do_token="$SRC_DIGITALOCEAN_TOKEN" \
    -var create_snapshot="true"

    # Get snapshot ID from Terraform output
    SNAPSHOT_ID=$(terraform output snapshot_id)
    NAME=$(terraform output name)
    REGIONS=$(terraform output regions)
    MIN_DISK_SIZE=$(terraform output min_disk_size)

    # Provide user with snapshot details
    echo "Snapshot ID: $SNAPSHOT_ID"
    echo "Name: $NAME"
    echo "Regions: $REGIONS"
    echo "Min Disk Size: $MIN_DISK_SIZE"
    echo "Please confirm the above details for the DEST vars in your .env before continuing. /
    Also please confirm that the SRC MIN_DISK_SIZE is correct or clean up will fail which will result in a charge."

    # Prompt the user and wait for confirmation
    read -pr "Are the above details correct? (yes/no) " response

    # Check the user's response
    while true; do
        case $response in
            [Yy]* ) break;;  # Exit the loop if user confirms
            [Nn]* ) exit 1;; # Exit the script if user denies
            * ) echo "Please answer yes or no."; read -p "Are the above details correct? (yes/no) " response;; # Prompt again if the response is not 'yes' or 'no'
        esac
    done

    # Provide user with instructions for the manual step
    echo "Snapshot has been created. Please go to the DigitalOcean Control Panel and:"
    echo "1. Navigate to Images -> Snapshots."
    echo "2. Select the snapshot and choose 'Change Owner' under 'More'."
    echo "3. Enter the destination team's email address and confirm the transfer."
    echo "After the snapshot transfer has been accepted, run this script with 'finalize'."

    # clean up
    terraform state rm digitalocean_droplet.web-snapshot
    terraform destroy -auto-approve -var do_token="$SRC_DIGITALOCEAN_TOKEN"
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
    terraform apply -auto-approve -var do_token="$DST_DIGITALOCEAN_TOKEN"
    echo "Complete..."
    cd ..

    echo "Moving data from droplet to volume..."
    ansible-playbook ansible/movetovolumen/playbook.yml
    echo "Complete..."

    cd snapshotVolume/
    echo "Creating snapshot volume..."
    terraform init
    terraform apply -auto-approve -var do_token="$DST_DIGITALOCEAN_TOKEN"
    echo "Complete..."

    echo "Cleaning up..."
    # clean up
    terraform destroy -auto-approve do_token="$SRC_DIGITALOCEAN_TOKEN"
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
