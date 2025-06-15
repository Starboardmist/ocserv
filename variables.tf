variable "yandex_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "yandex_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "yandex_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "yandex_zone" {
  description = "Yandex Cloud default zone"
  type        = string
  default     = "ru-central1-a"
}

variable "vm_image_ids" {
  description = "Map of VM image IDs"
  type        = map(string)
  default = {
    ubuntu = "fd8o5ddn529a6s8aldav"
  }
}
variable "ssh_public_key" {
  description = "SSH public key for authorized access"
  type        = string
}
