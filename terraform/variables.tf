variable "cloud_id" {
  type        = string
  description = "Yandex cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex folder id"
}

variable "zone_a" {
  type        = string
  default     = "ru-central1-a"
}

variable "zone_b" {
  type        = string
  default     = "ru-central1-b"
}

variable "public_key_bastion" {
  type        = string
  default     = "~/.ssh/bastion.pub"
  description = "Bastion's public key"
}

variable "public_key_internal" {
  type        = string
  default     = "~/.ssh/internal.pub"
  description = "Internal VM's pub key"
}

variable "image_family" {
  type        = string
  default     = "ubuntu-2204-lts"
}




