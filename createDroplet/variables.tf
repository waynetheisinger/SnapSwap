variable "do_token" {
  description = "The DigitalOcean API token."
  type        = string
  sensitive   = true
}

variable "volume_snapshot_name_regex" {
  description = "The regex for volume snapshot name identification."
  type        = string
}

variable "src_region" {
  description = "The source region where the volume is located."
  type        = string
}

variable "create_snapshot" {
  description = "Whether to create a snapshot of the droplet"
  type        = bool
  default     = false
}

variable "src_volume_size" {
  description = "The size of the volume to be copied"
  type        = string
}

variable "keys" {
  description = "DigitalOcean API SSH key ID."
}
