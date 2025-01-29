
resource "yandex_vpc_network" "main_network" {
  name        = "main-network"
  description = "Network for Public(Bastion) + Private(Compute + PostgresDB)"
}

resource "yandex_vpc_subnet" "main_subnet" {
  for_each = {
    for k, v in local.subnet_array : "${v.name}" => v
  }

  name        = each.value.name
  description = each.value.description

  network_id = yandex_vpc_network.main_network.id

  v4_cidr_blocks = each.value.cidr
  zone           = each.value.zone
}
