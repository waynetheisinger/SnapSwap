Absolutely. Let's adjust the README to reflect the changes related to having both a source and destination DigitalOcean token.

---

# SnapSwap

## 1. Introduction

### Brief Description
**SnapSwap** is an innovative open-source tool designed to facilitate and automate the process of transferring volume snapshots between teams on DigitalOcean. Born out of specific challenges encountered when managing volume snapshots across various teams, SnapSwap aims to provide a streamlined procedure that reduces manual intervention and boosts efficiency.

### Motivation
The complexity of transferring volume snapshots between DigitalOcean teams often presented users with a cumbersome procedure. SnapSwap emerged as a solution to bridge this gap, offering a method that is both swift and straightforward to implement.

## 2. Features

- Automated Snapshot Transfer: Seamless movement of volume snapshots between DigitalOcean teams with minimized manual steps.
- Integration with IaC Tools: Designed to synergize with tools such as Terraform and Ansible, delivering a comprehensive infrastructure solution.
- User-Friendly: A user-centric approach ensures the process is intuitive and accessible for users of varying expertise.

## 3. Prerequisites & Setup

### Tools & Dependencies
Ensure the following tools are installed and correctly configured:
- Packer
- Terraform
- Ansible

### DigitalOcean API Tokens
SnapSwap requires API tokens from DigitalOcean for both the source and destination teams:

1. **Environment Variables**: Set up the `SRC_DIGITALOCEAN_TOKEN` and `DST_DIGITALOCEAN_TOKEN` in your environment:
   ```bash
   export SRC_DIGITALOCEAN_TOKEN="your_source_api_token"
   export DST_DIGITALOCEAN_TOKEN="your_destination_api_token"
   ```

2. **Using an .env File**: For added convenience, SnapSwap supports loading your API tokens from an `.env` file. This method is especially handy for avoiding repetitive token setups or sharing configurations amongst teams without revealing sensitive data.

   Create an `.env` file in the root directory of SnapSwap with the following content:
   ```bash
   export SRC_DIGITALOCEAN_TOKEN="your_source_api_token"
   export DST_DIGITALOCEAN_TOKEN="your_destination_api_token"
   ```

3. **Error Handling**: Should the `SRC_DIGITALOCEAN_TOKEN` or `DST_DIGITALOCEAN_TOKEN` not be located either in the environment or the `.env` file, SnapSwap will terminate with an error message.

