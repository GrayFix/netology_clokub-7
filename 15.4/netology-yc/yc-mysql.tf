resource "yandex_mdb_mysql_cluster" "netology-mysql" {
  name                = "netology-mysql"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.netology-vpc.id
  version             = "8.0"
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ]
  deletion_protection = true

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  backup_window_start {
    hours = 23
    minutes = 59
  }
  
  maintenance_window {
    type = "ANYTIME"
  }

  database {
    name = var.yc_mysql_db
  }

  user {
    name     = var.yc_mysql_user
    password = var.yc_mysql_pass
    permission {
      database_name = var.yc_mysql_db
      roles         = ["ALL"]
    }
  }

  host {
    zone      = yandex_vpc_subnet.private-a.zone
    subnet_id = yandex_vpc_subnet.private-a.id
  }
  host {
    zone      = yandex_vpc_subnet.private-b.zone
    subnet_id = yandex_vpc_subnet.private-b.id
  }
  host {
    zone      = yandex_vpc_subnet.private-c.zone
    subnet_id = yandex_vpc_subnet.private-c.id
  }
}
