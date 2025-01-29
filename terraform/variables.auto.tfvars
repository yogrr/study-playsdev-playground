# ---------------------- main -----------------------
yc_cloud_id  = "b1g5b020anchqspg6qul"
yc_folder_id = "b1gs55f7ueeslt3ok3d5"
yc_zone      = "ru-central1-b"

# --------------------- network ---------------------
yc_network_name = "main-network"

# --------------------- subnet ----------------------

yc_public_subnet_name  = "public-subnet"
yc_private_subnet_name = "private-subnet"

yc_network_subnets = {
  "main-network" = [
    {
      cidr        = ["10.10.0.0/24"]
      description = "Private for Compute and PostgresDB"
      name        = "private-subnet" # yc_private_subnet_name must be equal
      zone        = "ru-central1-d"
    },
    {
      cidr        = ["10.11.0.0/24"]
      description = "Public for Bastion"
      name        = "public-subnet" # yc_public_subnet_name must be equal
      zone        = "ru-central1-b"
    }
  ]
}

# ------------------ external_ip -------------------
yc_external_static_ips = {
  ingress_lb = [
    {
      name = "ingress_lb_zone_ru_central1_a"
      zone = "ru-central1-b" # same as public's zone
    }
  ]
}

# ---------------- security_group ------------------
task_var = {
  name = "example-name"
  ip   = "104.28.214.127"
}

enable_ingress_ssh_by_ip = false

# ----------------------- vm -----------------------
yc_ssh_username    = "yogrr"
yc_ssh_pubkey_path = "~/.ssh/pd_yc.pub"
