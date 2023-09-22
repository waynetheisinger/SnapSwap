data "digitalocean_volume_snapshot" "snapshot" {
  name = "snapshot"
  name_regex  = var.volume_snapshot_name_regex
  region      = var.src_region
  most_recent = true
}

resource "digitalocean_volume" "src_volume" {
  region                  = var.src_region
  name                    = "src_volume"
  size                    = var.src_volume_size
  description             = "the main volume"
  snapshot_id = data.digitalocean_volume_snapshot.snapshot.id
}

# Create a new droplet
resource "digitalocean_droplet" "src_droplet" {
  name   = "snapswap-droplet"
  size   = "s-1vcpu-1gb" # Adjust the size as necessary
  image  = "ubuntu-20-04-x64" # Adjust the image as necessary
  region = var.src_region
  ssh_keys = split(",",var.keys)
  tags   = ["snapswap"] # Optional tags for better organization
  volume_ids = [digitalocean_volume.src_volume.id]
  user_data = <<-EOF
    #cloud-config
    mounts:
      - [ /dev/disk/by-id/scsi-0DO_Volume_src_volume, /mnt/volume_src_volume, "ext4", "defaults,nofail,discard", "0", "0" ]
    EOF
}

# Attach the identified volume to the newly created droplet
resource "digitalocean_volume_attachment" "volume_attachment" {
  droplet_id = digitalocean_droplet.src_droplet.id
  volume_id  = digitalocean_volume.src_volume.id
}

resource "digitalocean_droplet_snapshot" "web-snapshot" {
  count      = var.create_snapshot ? 1 : 0
  droplet_id = digitalocean_droplet.web.id
  name       = "web-snapshot-${timestamp()}"
}

# Generate inventory file
resource "local_file" "inventory" {
  filename = "./ansible/inventory.ini"
  content = <<EOF
[droplet]
droplet_host ansible_host=${digitalocean_droplet.src_droplet.ipv4_address} ansible_user=root
EOF
}
