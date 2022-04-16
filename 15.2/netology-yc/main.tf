terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token   
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

output "alb_external_address" {
   value = yandex_alb_load_balancer.netology-lemp-alb.listener[0].endpoint[0].address[0].external_ipv4_address[0]
}