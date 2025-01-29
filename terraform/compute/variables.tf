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

# --------------------- subnet ----------------------
variable "yc_public_subnet_id" {
  description = "ID of public subnet"
  type        = string
}

variable "yc_private_subnet_id" {
  description = "ID of public subnet"
  type        = string
}

# ----------------------- vm ------------------------
variable "yc_ssh_username" {
  description = "Username that will be used in ssh-auth"
  type        = string
}

variable "yc_ssh_pubkey_path" {
  description = "ssh public key for ssh-auth to compute instances"
  type        = string
}

variable "yc_public_ipv4_addresses" {
  description = <<EOF
Public IPs info. Map with key-value, where"
  key is `name` from module network var `yc_external_static_ips`'s `name` field
  value is `yandex_vpc_address` resource
EOF
}

variable "yc_sg_id_main_network" {
  description = "Security Group's ID that will be used in public VM"
  type        = string
}
