# Настройка сетей

resource "yandex_vpc_network" "netology-vpc" {
  name = "netology-vpc"
}

resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.zone-a
  network_id     = yandex_vpc_network.netology-vpc.id
}

resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  v4_cidr_blocks = ["192.168.21.0/24"]
  zone           = var.zone-b
  network_id     = yandex_vpc_network.netology-vpc.id
}

resource "yandex_vpc_subnet" "private-c" {
  name           = "private-c"
  v4_cidr_blocks = ["192.168.22.0/24"]
  zone           = var.zone-c
  network_id     = yandex_vpc_network.netology-vpc.id
}

resource "yandex_vpc_subnet" "public-a" {
  name           = "public-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.zone-a
  network_id     = yandex_vpc_network.netology-vpc.id
}

resource "yandex_vpc_subnet" "public-b" {
  name           = "public-b"
  v4_cidr_blocks = ["192.168.11.0/24"]
  zone           = var.zone-b
  network_id     = yandex_vpc_network.netology-vpc.id
}

resource "yandex_vpc_subnet" "public-c" {
  name           = "public-c"
  v4_cidr_blocks = ["192.168.12.0/24"]
  zone           = var.zone-c
  network_id     = yandex_vpc_network.netology-vpc.id
}