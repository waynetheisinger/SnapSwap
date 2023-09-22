output "droplet_id" {
  description = "The ID of the created droplet."
  value       = digitalocean_droplet.src_droplet.id
}

output "droplet_name" {
  description = "The name of the created droplet."
  value       = digitalocean_droplet.src_droplet.name
}

output "droplet_ip_address" {
  description = "The public IP address of the created droplet."
  value       = digitalocean_droplet.src_droplet.ipv4_address
}

output "volume_id" {
  description = "The ID of the volume identified based on the provided regex."
  value       = data.digitalocean_volume.src_volume.id
}

output "volume_name" {
  description = "The name of the volume identified based on the provided regex."
  value       = data.digitalocean_volume.src_volume.name
}

output "volume_attachment_id" {
  description = "The ID of the volume attachment to the created droplet."
  value       = digitalocean_volume_attachment.volume_attachment.id
}
