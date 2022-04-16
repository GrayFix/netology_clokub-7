# Настройка сетей

resource "yandex_vpc_network" "netology-vpc" {
  name = "netology-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.zone
  network_id     = "${yandex_vpc_network.netology-vpc.id}"
}
