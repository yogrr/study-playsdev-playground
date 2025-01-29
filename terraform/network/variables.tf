# ---------------------- main -----------------------
variable "yc_cloud_id" {
  description = "Yandex.Cloud's working cloud ID"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex.Cloud's working directory ID"
  type        = string
}

variable "yc_zone" {
  description = "Yandex.Cloud's Compute default zone"
  type        = string
}

# --------------------- network ---------------------
variable "yc_network_name" {
  description = "Yandex.Cloud VPC's network name"
  type        = string
}

# --------------------- subnet ----------------------
variable "yc_network_subnets" {
  description = "Subnets for Yandex.Cloud VPC's network"

  type = map(list(object({
    name        = string,
    description = string,
    zone        = string,
    cidr        = list(string)
  })))
}

# ------------------ external_ip -------------------
variable "yc_external_static_ips" {
  description = "Static IPs info for address resourse"

  type = map(list(object(
    {
      name = string,
      zone = string
    }))
  )
}

# ---------------- security_group ------------------
variable "task_var" { # ip from which will be access to bastion
  type = object({
    name = string
    ip   = string
  })
}

variable "enable_ingress_ssh_by_ip" {
  type        = bool
  description = "If true task_var.ip will be use as IP from which will be access to bastion"
}
