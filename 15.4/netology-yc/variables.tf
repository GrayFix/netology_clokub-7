variable "cloud_id" {
  type    = string
}

variable "folder_id" {
  type    = string
}

variable "zone" {
  type    = string
}

variable "zone-a" {
  type    = string
  default = "ru-central1-a"
}

variable "zone-b" {
  type    = string
  default = "ru-central1-b"
}

variable "zone-c" {
  type    = string
  default = "ru-central1-c"
}

variable "yc_token" {
  type    = string
}

variable "yc_mysql_db" {
  type = string
}
variable "yc_mysql_user" {
  type = string
}
variable "yc_mysql_pass" {
  type = string
}

variable "yc_kube_ver" {
  type = string
}