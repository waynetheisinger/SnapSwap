terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

# Define provider details
provider "digitalocean" {
  token = var.do_token
}
