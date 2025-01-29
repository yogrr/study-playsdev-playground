locals {
  subnet_array = flatten([for k, v in var.yc_network_subnets : [for j in v : {
    name        = j.name
    description = j.description
    zone        = j.zone
    cidr        = j.cidr
    }
  ]])
  external_ips_array = flatten([for k, v in var.yc_external_static_ips : [for j in v : {
    name = j.name
    zone = j.zone
    }
  ]])
}
