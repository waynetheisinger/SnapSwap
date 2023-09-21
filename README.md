# SnapSwap

## 1. Introduction

### Brief Description
**SnapSwap** is an open-source tool designed to facilitate and automate the process of transferring volume 
snapshots between teams on DigitalOcean.

### Motivation
The complexity of transferring volume snapshots between DigitalOcean teams required a more streamlined process. SnapSwap
provides a method that merges automation with manual checks for a safe and straightforward transfer experience.

## 2. Features

- **Two-Phase Transfer**: Breaks down the snapshot transfer into two primary phases, allowing users to have control and 
  visibility over the process.
- **Integrated with IaC Tools**: Designed to work seamlessly with Packer, Terraform, and Ansible, providing a comprehensive 
  infrastructure solution.
- **User-Friendly Workflow**: Detailed instructions guide the user through each step, making the process accessible even 
  for those unfamiliar with DigitalOcean's infrastructure.

---

## Prerequisites & Setup

### Tools & Dependencies
Ensure the following tools are installed and properly configured:
- Packer
- Terraform
- Ansible
- **doctl** - The official DigitalOcean CLI tool. [Installation Instructions](https://www.digitalocean.com/docs/apis-clis/doctl/how-to/install/)

### DigitalOcean API Tokens

Before using SnapSwap, you'll need API tokens for both the source and destination teams.

1. **Obtain API Tokens using `doctl`**:

   If you've set up `doctl` with access to your DigitalOcean account, you can list your account's API tokens using:

   ```bash
   doctl account api-tokens list
   ```

   Identify the appropriate tokens you wish to use for the source and destination teams. If you need to create a new API token, this can be done through the [DigitalOcean Control Panel](https://cloud.digitalocean.com/account/api/tokens).

2. Set up the identified tokens as `SRC_DIGITALOCEAN_TOKEN` and `DST_DIGITALOCEAN_TOKEN` respectively in your `.env` file.

### Identifying Volume ID

To determine the `VOLUME_ID` for the volume snapshot you wish to transfer, use the `doctl` CLI:

1. **List Volume Snapshots**:

   ```bash
   doctl compute volume list-snapshots
   ```

   This command will display a list of volume snapshots along with their respective IDs. Locate the desired snapshot and take note of its ID.

2. Update this ID as the `VOLUME_ID` in your `.env` file.

---
## 4. Usage

1. **Snapshot Creation and Transfer Initiation**:

   Start by creating a snapshot and preparing it for transfer:
   ```bash
   ./snapswap_tool.sh create-snapshot
   ```

   After running the above command, SnapSwap will guide you through the manual steps required to complete the snapshot 
   transfer via the DigitalOcean Control Panel.

2. **Finalize Transfer**:

   Once you've completed the manual snapshot transfer, proceed with the following:
   ```bash
   ./snapswap_tool.sh finalize
   ```

   This step will complete the process, performing any necessary post-transfer tasks to ensure the volume snapshot is properly 
   set up in the destination team.

---

## 5. Handling the `.env` File

The repository includes a dummy `.env` file to help users set up their environment variables. 
After setting up your own configuration in the `.env` file, you will want to avoid tracking changes to this file to 
prevent accidentally committing personal or sensitive information.

To ensure your changes to `.env` are not tracked by Git:

```bash
git update-index --assume-unchanged .env
```

By running this command, Git will ignore future changes to the `.env` file locally.

**Important**: Each collaborator or user who clones the repository and modifies the `.env` file should run the above 
command to ensure their changes remain untracked.

If, at any point, you wish to commit changes to the `.env` file again, use:

```bash
git update-index --no-assume-unchanged .env
```

This will tell Git to track changes to the `.env` file once more.




