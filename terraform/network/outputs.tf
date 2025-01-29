# --------------------- network ---------------------
output "network_id" {
  description = "ID of created main-network"
  value       = yandex_vpc_network.main_network.id
}

# --------------------- subnet ----------------------
output "network_subnet" {
  description = "Created main-network's subnet info"
  value       = yandex_vpc_subnet.main_subnet
}

# --------------------- subnet ----------------------
output "yc_vpc_ipv4_addresses" {
  description = "Public IPv4 from main-network"
  value       = yandex_vpc_address.public_addr_main_network
}

# ---------------- security_groups ------------------
output "yc_sg_id_main_network" {
  description = "Security Group for main-network's ID"
  value       = yandex_vpc_security_group.sg_main_network.id
}
