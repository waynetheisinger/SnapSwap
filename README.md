# SnapSwap

## 1. Introduction

### Brief Description

**SnapSwap** is an open-source tool designed to facilitate and automate the process of transferring volume snapshots
between teams on DigitalOcean.

### Motivation

The complexity of transferring volume snapshots between DigitalOcean teams required a more streamlined process. SnapSwap
provides a method that merges automation with manual checks for a safe and straightforward transfer experience.

## 2. Features

- **Two-Phase Transfer**: Breaks down the snapshot transfer into two primary phases, allowing users to have control and
  visibility over the process.
- **Integrated with IaC Tools**: Designed to work seamlessly with Terraform and Ansible, providing a comprehensive
  infrastructure solution.
- **User-Friendly Workflow**: Detailed instructions guide the user through each step, making the process accessible even
  for those unfamiliar with DigitalOcean's infrastructure.

---

## Prerequisites & Setup

### Tools & Dependencies

Ensure the following tools are installed and properly configured:

- Terraform
- Ansible

### DigitalOcean API Tokens

Before using SnapSwap, you'll need API tokens for both the source and destination teams.

1. **Obtain API Tokens**: Create a new API token through
   the [DigitalOcean Control Panel](https://cloud.digitalocean.com/account/api/tokens).
2. Set up the obtained tokens as `SRC_DIGITALOCEAN_TOKEN` and `DST_DIGITALOCEAN_TOKEN` respectively in your `.env` file.

### Identifying Volume Snapshot By Name

Instead of using a volume Snapshot ID, SnapSwap uses a name regex to identify the volume snapshot you wish to copy. To
determine the name of the volume you wish to transfer, visit
the [DigitalOcean Control Panel](https://cloud.digitalocean.com/). Navigate to the "Volumes" section and locate the
desired volume. Take note of its name and update this in your `.env` file.

### Configuring the `.env` File

The `.env` file contains environment variables used by SnapSwap. The repository includes a dummy `.env` file to help
users set up their environment variables. After configuring the `.env` file.
To set up the `.env` file you will need to gather the following information:
* **Source and Destination DigitalOcean API Tokens**: Create a new API token through
   the [DigitalOcean Control Panel](https://cloud.digitalocean.com/account/api/tokens).
* **Volume Snapshot Name Regex**: Instead of using a volume Snapshot ID, SnapSwap uses a name regex to identify the
  volume snapshot you wish to copy. To determine the name of the volume you wish to transfer, visit
  the [DigitalOcean Control Panel](https://cloud.digitalocean.com/). Navigate to the "Volumes" section and locate the
  desired volume. Take note of its name and update this in your `.env` file.
* **Source and Destination Regions**: The regions where the source and destination volumes are located. To determine the
  region of a volume, visit the [DigitalOcean Control Panel](https://cloud.digitalocean.com/). Navigate to the "Volumes"
  section and locate the desired volume. Take note of its region and update this in your `.env` file.
* **Source and Destination Volume Sizes**: The size of the source and destination volumes. To determine the size of a
  volume, visit the [DigitalOcean Control Panel](https://cloud.digitalocean.com/). Navigate to the "Volumes" section and
  locate the desired volume. Take note of its size and update this in your `.env` file.

```shell
export SRC_DIGITALOCEAN_TOKEN="your_token_here"
export DST_DIGITALOCEAN_TOKEN="your_token_here"
export VOLUME_SNAPSHOT_NAME_REGEX="your_volume_snapshot_regex_here"
export SRC_REGION="your_region_here"
export DST_REGION="your_region_here"
export SRC_VOLUME_SIZE="your_volume_size_here"
export DST_VOLUME_SIZE="your_volume_size_here"
```
---

## 4. Usage

1. **Snapshot Creation and Transfer Initiation**: Start by creating a snapshot and preparing it for transfer.
   ```bash
   ./snapswap.sh create-snapshot
   ```
   SnapSwap will guide you through the manual steps required to complete the snapshot transfer via the DigitalOcean
   Control Panel.

2. **Finalize Transfer**: After completing the manual snapshot transfer, proceed with the following step to finalize the
   process.
   ```bash
   ./snapswap.sh finalize
   ```

---

## 5. Handling the `.env` File

The repository includes a dummy `.env` file to help users set up their environment variables. After configuring
the `.env` file, avoid tracking changes to this file to prevent accidentally committing personal or sensitive
information. To ensure changes to `.env` are untracked by Git, execute:

```bash
git update-index --assume-unchanged .env
```

By running this command, Git will ignore future changes to the `.env` file locally. **Important**: Collaborators or
users modifying the `.env` file should run the above command. To track changes to the `.env` file again, use:

```bash
git update-index --no-assume-unchanged .env
```
