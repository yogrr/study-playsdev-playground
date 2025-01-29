locals {
  subnet = data.yandex_vpc_subnet.private_subnet
}

resource "yandex_mdb_postgresql_cluster" "main_cluster_postgres" {
  name        = "main-cluster-postgres"
  environment = "PRODUCTION"
  network_id  = local.subnet.network_id

  config {
    version = 16
    resources {
      resource_preset_id = "c3-c2-m4"
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }
  }

  host {
    zone      = local.subnet.zone
    subnet_id = local.subnet.subnet_id
  }
}
