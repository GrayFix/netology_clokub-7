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

resource "yandex_vpc_network" "netology-vpc" {
  name = "netology-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.zone
  network_id     = "${yandex_vpc_network.netology-vpc.id}"
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.zone
  network_id     = "${yandex_vpc_network.netology-vpc.id}"
  route_table_id = "${yandex_vpc_route_table.private-rt.id}"
}

resource "yandex_vpc_route_table" "private-rt" {
  name       = "private-rt"
  network_id = "${yandex_vpc_network.netology-vpc.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_ip
  } 
}

resource "yandex_compute_instance" "public-nat" {
  name        = "public-nat"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = var.yc_image_nat_id
      
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}"
    ip_address = var.nat_ip
    nat = true
  }
  metadata = {
    user-data = "${file("auth-meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 4
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = var.yc_image_ubuntu_id
      
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}"
    nat = true
  }
  metadata = {
    user-data = "${file("auth-meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "private-vm" {
  name        = "private-vm"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 4
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = var.yc_image_ubuntu_id
     }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.private.id}"
  }
  metadata = {
    user-data = "${file("auth-meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}


output "public-vm_ip" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

output "public-nat_ip" {
  value = yandex_compute_instance.public-nat.network_interface.0.nat_ip_address
}

output "private-vm_ip" {
  value = yandex_compute_instance.private-vm.network_interface.0.ip_address
}