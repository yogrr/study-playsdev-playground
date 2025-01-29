data "yandex_vpc_subnet" "private_subnet" {
  subnet_id = var.yc_db_subnet
}
