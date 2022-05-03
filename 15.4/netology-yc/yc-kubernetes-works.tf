resource "yandex_kubernetes_node_group" "netology-kube-work-nodes-a" {
  cluster_id  = yandex_kubernetes_cluster.netology-kube.id
  name        = "netology-kube-work-nodes-a"
  version     = var.yc_kube_ver

  labels = {
    "type" = "netology"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.public-a.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 50
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
      auto_scale {
        min = 3
        max = 6
        initial = 3
      }
  }

  allocation_policy {
    location {
      zone = var.zone-a
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}