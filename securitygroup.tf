data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["default-vpc"]
  }
}

# declare local variable
locals {
  ports = [22,53,80,443,1521,3306,3389]
}

# creare a security group from local
resource "aws_security_group" "management" {
  name="management-sg"
  description = "Allows wellknown services for admin"
  vpc_id = data.aws_vpc.selected.id

  dynamic "ingress" {
    for_each = local.ports
    content {
      description = "description ${ingress.key}"
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
resource "aws_security_group" "management" {
  name="management-sg"
  description = "Allows SSH for admin"
#   vpc_id = "vpc-0ed30604d04a09dc4"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "ICMP"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "management-sg"
  }
}
*/