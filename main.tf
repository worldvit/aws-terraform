# Create public key
resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Create VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = { Name = "vpc1"}
}

# create public subnets
resource "aws_subnet" "vpc1-public-subnet-0" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.0.0/20"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-2a"
  tags = { Name = "public-subnet-0"}
}

resource "aws_subnet" "vpc1-public-subnet-16" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.16.0/20"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-2b"
  tags = { Name = "public-subnet-16"}
}

resource "aws_subnet" "vpc1-public-subnet-32" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.32.0/20"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-2c"
  tags = { Name = "public-subnet-32"}
}

resource "aws_subnet" "vpc1-public-subnet-48" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.48.0/20"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-2d"
  tags = { Name = "public-subnet-48"}
}

# create private subnets
resource "aws_subnet" "vpc1-private-subnet-64" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.64.0/20"
  availability_zone = "us-west-2a"
  tags = { Name = "private-subnet-64"}
}

resource "aws_subnet" "vpc1-private-subnet-80" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.80.0/20"
  availability_zone = "us-west-2b"
  tags = { Name = "private-subnet-80"}
}

resource "aws_subnet" "vpc1-private-subnet-96" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.96.0/20"
  availability_zone = "us-west-2c"
  tags = { Name = "private-subnet-96"}
}

resource "aws_subnet" "vpc1-private-subnet-112" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.112.0/20"
  availability_zone = "us-west-2d"
  tags = { Name = "private-subnet-112"}
}

# create Internet Gateway
resource "aws_internet_gateway" "vpc1-igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = { Name = "vpc1-igw"}
}

# create a public route
resource "aws_route_table" "vpc1-public" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1-igw.id
  }
  tags = { Name = "vpc1-public"}
}

# route associateions public
resource "aws_route_table_association" "vpc1-public-subnet-0" {
  subnet_id = aws_subnet.vpc1-public-subnet-0.id
  route_table_id = aws_route_table.vpc1-public.id
}

resource "aws_route_table_association" "vpc1-public-subnet-16" {
  subnet_id = aws_subnet.vpc1-public-subnet-16.id
  route_table_id = aws_route_table.vpc1-public.id
}

resource "aws_route_table_association" "vpc1-public-subnet-32" {
  subnet_id = aws_subnet.vpc1-public-subnet-32.id
  route_table_id = aws_route_table.vpc1-public.id
}

resource "aws_route_table_association" "vpc1-public-subnet-48" {
  subnet_id = aws_subnet.vpc1-public-subnet-48.id
  route_table_id = aws_route_table.vpc1-public.id
}

# create a private route
resource "aws_route_table" "vpc1-private" {
  vpc_id = aws_vpc.vpc1.id
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.natgw.id
  # }
  tags = { Name = "vpc1-private"}
}

# route associateions private
resource "aws_route_table_association" "vpc1-private-subnet-64" {
  subnet_id = aws_subnet.vpc1-private-subnet-64.id
  route_table_id = aws_route_table.vpc1-private.id
}

resource "aws_route_table_association" "vpc1-private-subnet-80" {
  subnet_id = aws_subnet.vpc1-private-subnet-80.id
  route_table_id = aws_route_table.vpc1-private.id
}

resource "aws_route_table_association" "vpc1-private-subnet-96" {
  subnet_id = aws_subnet.vpc1-private-subnet-96.id
  route_table_id = aws_route_table.vpc1-private.id
}

resource "aws_route_table_association" "vpc1-private-subnet-112" {
  subnet_id = aws_subnet.vpc1-private-subnet-112.id
  route_table_id = aws_route_table.vpc1-private.id
}

# creare a security group from local
resource "aws_security_group" "management" {
  name="management-sg"
  description = "Allows wellknown services for admin"
  vpc_id = aws_vpc.vpc1.id

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

# get an ami for amazon
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# get an ami for ubuntu
data "aws_ami" "ubuntu-linux" {
  most_recent = true
  owners = [ "099720109477" ]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# Create an instance using amazon ami
resource "aws_instance" "web" {
  # ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  count = 3
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["aws_security_group.management.id"]
  subnet_id = "aws_subnet.vpc1-public-subnet-0.id"

  root_block_device {
    volume_size = "20"
    volume_type = "gp2"

    tags = {
      Name = "root-device"
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo systemctl enable --now nginx
    echo "WEB Pages" | sudo tee /usr/share/nginx/html/index.html
    sudo systemctl restart nginx
  EOF

  tags = {
    Name = "web-${count.index}"
  }
}

# Create an instance using ubuntu ami
resource "aws_instance" "database" {
#   ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  count = 3
  ami = data.aws_ami.ubuntu-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids =  ["aws_security_group.management.id"]
  subnet_id = "aws_subnet.vpc1-public-subnet-16.id"
  associate_public_ip_address = true

  root_block_device {
    volume_size = "20"
    volume_type = "gp2"

    tags = {
      Name = "root-device"
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    sudo systemctl enable --now nginx
    echo "WEB Pages" | sudo tee /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "database-${count.index}"
  }
}

/*
# Get vpc from an existing vpc
data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["default-vpc"]
  }
}
*/

/*
# declare local variable
locals {
  ports = [22,53,80,443,1521,3306,3389]
}
*/

/*
1차적으로 실습
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

/*
# get a subnet from default vpc
data "aws_subnet" "subnet-0" {
  filter {
    name="tag:Name"
    values = ["default-subnet-0"]
  }
}
data "aws_subnet" "subnet-16" {
  filter {
    name="tag:Name"
    values = ["default-subnet-16"]
  }
}
data "aws_subnet" "subnet-32" {
  filter {
    name="tag:Name"
    values = ["default-subnet-32"]
  }
}
data "aws_subnet" "subnet-48" {
  filter {
    name="tag:Name"
    values = ["default-subnet-48"]
  }
}
*/