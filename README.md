# SnapSwap

## 1. Introduction

### Brief Description
**SnapSwap** is an innovative open-source tool designed to simplify and automate the process of transferring volume snapshots between teams on DigitalOcean. Born out of the specific challenges faced in managing volume snapshots across different teams, SnapSwap streamlines the procedure, minimizing manual intervention and maximizing efficiency.

### Motivation
Transferring volume snapshots between DigitalOcean teams often presented users with a cumbersome process. SnapSwap was developed to bridge this gap, providing a solution that is both quick and easy to implement.

## 2. Features

- Automated Snapshot Transfer: Seamlessly move volume snapshots between DigitalOcean teams with reduced manual steps.
- Integration with IaC Tools: Designed to integrate with tools like Terraform and Ansible for a comprehensive infrastructure solution.
- User-Friendly: An intuitive process designed for users of all expertise levels.

## 3. Prerequisites & Setup

### Tools & Dependencies
Ensure you have the following tools installed and configured:
- Packer
- Terraform
- Ansible

### DigitalOcean API Token
Before using SnapSwap, you'll need an API token from DigitalOcean for the source and target teams:

1. **Environment Variable**: You can set up the `DIGITALOCEAN_TOKEN` directly in your environment:
   ```bash
   export DIGITALOCEAN_TOKEN="your_api_token"
   ```

2. **Using an .env File**: Alternatively, SnapSwap supports loading your API token from an `.env` file. This method is especially useful to avoid setting up the token every time or to share configurations among a team without exposing sensitive information.

   Create an `.env` file in the root directory of SnapSwap and add the following:
   ```bash
   export DIGITALOCEAN_TOKEN="your_api_token"
   ```

   Ensure you add `.env` to your `.gitignore` to prevent accidental exposure of your token in version control:
   ```bash
   echo ".env" >> .gitignore
   ```

3. **Error Handling**: If the `DIGITALOCEAN_TOKEN` is not found in either the environment or the `.env` file, SnapSwap will exit with an error message.

