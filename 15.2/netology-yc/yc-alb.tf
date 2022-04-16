# Создание группы бэкенд таргетов
resource "yandex_alb_backend_group" "netology-lemp-backend-group" {
  name      = "netology-lemp-backend-group"

  http_backend {
    name = "http-cig-lemp"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_compute_instance_group.cig-lemp.application_load_balancer[0].target_group_id}"]

    load_balancing_config {
      panic_threshold = 50
    }    

    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/"
      }
    }
  }
}

# Создание http роутера
resource "yandex_alb_http_router" "netology-lemp-http-router" {
   name      = "netology-lemp-http-router"
 }

#Создание виртуального хоста для http роутера
resource "yandex_alb_virtual_host" "netology-lemp-virtual-host" {
  name      = "netology-lemp-virtual-host"
  http_router_id = yandex_alb_http_router.netology-lemp-http-router.id
  route {
    name = "netology-lemp-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.netology-lemp-backend-group.id
        timeout = "3s"
      }
    }
  }
}

# Создание сетевого балансировщика L7
resource "yandex_alb_load_balancer" "netology-lemp-alb" {
  name        = "netology-lemp-alb"

  network_id  = yandex_vpc_network.netology-vpc.id

  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "http"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.netology-lemp-http-router.id
      }
    }
  }    
}
