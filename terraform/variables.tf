# ---------------------- main -----------------------
variable "yc_cloud_id" {}
variable "yc_folder_id" {}
variable "yc_zone" {}

# --------------------- network ---------------------
variable "yc_network_name" {}

# --------------------- subnet ----------------------
variable "yc_public_subnet_name" {
  description = "Public subnet name"
  type        = string
}

variable "yc_private_subnet_name" {
  description = "Private subnet name"
  type        = string
}

variable "yc_network_subnets" {}

# ------------------ external_ip -------------------
variable "yc_external_static_ips" {}

# ---------------- security_group ------------------
variable "task_var" {}
variable "enable_ingress_ssh_by_ip" {}

# ----------------------- vm ------------------------
variable "yc_ssh_username" {}
variable "yc_ssh_pubkey_path" {}

