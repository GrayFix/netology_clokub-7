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

 output "mysql_host_address" {
    value = "MySQL host: ${yandex_mdb_mysql_cluster.netology-mysql.host[0].fqdn}"
 }

 output "kubectl_init" {
    value = "kubectl init kommand: yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.netology-kube.id} --external"
 }
 