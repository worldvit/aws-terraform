module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "main"
  cidr = var.cidr_block
  azs = var.availability_zones
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets


  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  enable_vpn_gateway = false


  tags = {
    name = "main"
  }
}


resource "aws_eip" "nat" {
//  vpc = true
  tags = {
    "name" = "main-nat-eip"
  }
}


resource "aws_nat_gateway" "main-ngw" {
  subnet_id = module.vpc.public_subnets[0]
  connectivity_type = "public"
  allocation_id = aws_eip.nat.id


  tags = {
    "name" = "main-ngw"
  }
}


# VPC setup for NAT
resource "aws_route_table" "main-private" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-ngw.id
  }
  tags = {
    Name = "main-private-1"
  }
}
