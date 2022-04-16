# Определение instance group

resource "yandex_compute_instance_group" "cig-lemp" {
  name               = "netology-lemp-cig"
  service_account_id = "${yandex_iam_service_account.ig-sa.id}"
  depends_on          = [yandex_resourcemanager_folder_iam_binding.editor]
  instance_template {
    platform_id = "standard-v1"

    resources {
      cores  = 2
      memory = 4
      core_fraction = 5
    }
    boot_disk {
      initialize_params {
        image_id = var.yc_image_vm_id
        
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.netology-vpc.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
#      nat = true     #  Для теста для получения внешнего IP на каждую машину
    }
    metadata = {
      user-data = "${file("auth-meta.txt")}"
    }
    scheduling_policy {
      preemptible = true  # Прерываемая
    }
  }

  scale_policy {
    fixed_scale {
      size = var.yc_cig_count
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
  
  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }

  application_load_balancer {
    target_group_name        = "netology-lemp-target-group"
    target_group_description = "load balancer target group"
  }
}

