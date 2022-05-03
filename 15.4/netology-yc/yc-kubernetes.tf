resource "yandex_kubernetes_cluster" "netology-kube" {
 name = "netology-kube"
 network_id = yandex_vpc_network.netology-vpc.id
 release_channel = "STABLE"
 

  kms_provider {
    key_id = "${yandex_kms_symmetric_key.kms-kube-netology.id}"
  }

 master {
   version   = var.yc_kube_ver
   public_ip = true
   regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.public-a.zone
        subnet_id = yandex_vpc_subnet.public-a.id
      }

      location {
        zone      = yandex_vpc_subnet.public-b.zone
        subnet_id = yandex_vpc_subnet.public-b.id
      }

      location {
        zone      = yandex_vpc_subnet.public-c.zone
        subnet_id = yandex_vpc_subnet.public-c.id
      }
   }
 }
 
 service_account_id      = yandex_iam_service_account.sa-netology-kube.id
 node_service_account_id = yandex_iam_service_account.sa-netology-kube.id
   depends_on = [
     yandex_resourcemanager_folder_iam_binding.editor,
     yandex_resourcemanager_folder_iam_binding.images-puller
   ]
}