terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone

  service_account_key_file = "key.json"
}

module "network" {
  source = "./network"

  yc_cloud_id            = var.yc_cloud_id
  yc_folder_id           = var.yc_folder_id
  yc_network_name        = var.yc_network_name
  yc_network_subnets     = var.yc_network_subnets
  yc_zone                = var.yc_zone
  yc_external_static_ips = var.yc_external_static_ips

  task_var                 = var.task_var
  enable_ingress_ssh_by_ip = false
}

module "bastion-private" {
  source = "./compute"

  yc_cloud_id        = var.yc_cloud_id
  yc_folder_id       = var.yc_folder_id
  yc_ssh_username    = var.yc_ssh_username
  yc_ssh_pubkey_path = var.yc_ssh_pubkey_path
  yc_zone            = var.yc_zone

  yc_private_subnet_id     = module.network.network_subnet[var.yc_private_subnet_name].id
  yc_public_ipv4_addresses = module.network.yc_vpc_ipv4_addresses
  yc_public_subnet_id      = module.network.network_subnet[var.yc_public_subnet_name].id
  yc_sg_id_main_network    = module.network.yc_sg_id_main_network
}

# Turn me on, if you want DB
# module "database" {
#   source = "./db"

#   yc_db_subnet = module.network.network_subnet[var.yc_public_subnet_name].id
# }
