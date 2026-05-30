terraform {
    required_providers {
      yandex = {
        source = "yandex-cloud/yandex"
        version = ">=0.104"
      }
    }
  required_version = ">= 0.13"
}

provider "yandex" {
    cloud_id  = var.cloud_id
    folder_id = var.folder_id
    token     = var.token
}