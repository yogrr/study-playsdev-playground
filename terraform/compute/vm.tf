locals {
  public_subnet  = data.yandex_vpc_subnet.public_subnet
  private_subnet = data.yandex_vpc_subnet.private_subnet

  ipv4_bastion_static = values(var.yc_public_ipv4_addresses)[0].external_ipv4_address[0].address

  bastion_sg_id = data.yandex_vpc_security_group.sg_main_network.security_group_id
}

# TODO: rewrite with `for loop` for bastion and private
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  description = "Bastion VM at public subnet"
  platform_id = "standard-v3"
  zone        = local.public_subnet.zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts_latest.id
      size     = 10
    }
  }

  network_interface {
    nat                = true
    nat_ip_address     = local.ipv4_bastion_static
    security_group_ids = [local.bastion_sg_id]
    subnet_id          = local.public_subnet.subnet_id
  }

  metadata = {
    ssh-keys = "${var.yc_ssh_username}:${file("${var.yc_ssh_pubkey_path}")}"
  }
}

resource "yandex_compute_instance" "private" {
  name        = "private"
  hostname    = "private"
  description = "Private VM at public subnet"
  platform_id = "standard-v3"
  zone        = local.private_subnet.zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts_latest.id
      size     = 10
    }
  }

  network_interface {
    subnet_id = local.private_subnet.subnet_id
  }

  metadata = {
    ssh-keys = "${var.yc_ssh_username}:${file("${var.yc_ssh_pubkey_path}")}"
  }
}
