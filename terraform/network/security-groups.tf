resource "yandex_vpc_security_group" "sg_main_network" {
  name        = "sg-${yandex_vpc_network.main_network.name}-${var.task_var.name}"
  description = "Security Group for ${yandex_vpc_network.main_network.name}"
  network_id  = yandex_vpc_network.main_network.id

  dynamic "ingress" {
    for_each = var.enable_ingress_ssh_by_ip ? [1] : []
    content {
      protocol       = "TCP"
      description    = "SSH"
      v4_cidr_blocks = ["${var.task_var.ip}/32"]
      port           = 22
    }
  }

  egress {
    protocol       = "ANY"
    description    = "To the internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
