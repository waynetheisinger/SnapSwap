source "digitalocean" "snapswap" {
  api_token      = var.do_api_token
  image          = "ubuntu-20-04-x64"
  region         = "nyc3"
  size           = "s-1vcpu-1gb"
  ssh_username   = "root"
  droplet_name   = "snapswap-builder"
}
