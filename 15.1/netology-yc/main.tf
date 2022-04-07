terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
   
  cloud_id  = "b1gu9piqq14p2h00buhe"
  folder_id = "b1gjolnnoe2770jcqeg5"
  zone      = "ru-central1-b"
}