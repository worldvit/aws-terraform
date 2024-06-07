# creare a security group from local
resource "aws_security_group" "management" {
  name="management-sg"
  description = "Allows wellknown services for admin"
  vpc_id = var.vpc1

  dynamic "ingress" {
    # for_each = local.ports
    for_each = var.management-sg
    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "management-sg"}
}

output "sg_management_id" {
  value = aws_security_group.management.id
}