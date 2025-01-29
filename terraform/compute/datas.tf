data "yandex_compute_image" "ubuntu_2204_lts_latest" {
  family    = "ubuntu-2004-lts-oslogin"
  folder_id = "standard-images"
}

data "yandex_vpc_subnet" "public_subnet" {
  subnet_id = var.yc_public_subnet_id
}

data "yandex_vpc_subnet" "private_subnet" {
  subnet_id = var.yc_private_subnet_id
}

data "yandex_vpc_security_group" "sg_main_network" {
  security_group_id = var.yc_sg_id_main_network
}
