build {
  sources = ["source.digitalocean.snapswap"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y jq",
      "curl -X POST -H \"Content-Type: application/json\" -H \"Authorization: Bearer ${var.do_api_token}\" -d '{\"type\":\"attach\",\"droplet_id\": \"${build.DropletID}\",\"volume_id\": \"${var.volume_id}\"}' \"https://api.digitalocean.com/v2/volumes/${var.volume_id}/actions\"",
      "mkdir -p /dataTransfer",
      "mount /dev/disk/by-id/scsi-0DO_Volume_volume-nyc3-01 /mnt/volume_data",
      "cp -R /mnt/volume_data/* /dataTransfer/",
      "umount /mnt/volume_data"
    ]
  }
}
}
