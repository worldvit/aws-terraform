################
# Data section #
################
# get a policy
data "aws_iam_policy" "Administrator_Access" {
  name="AdministratorAccess"
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

# Create users
/*
resource "aws_iam_user" "adam" {
  name = "adam.god"
}

resource "aws_iam_user" "eve" {
  name = "eve"

  tags = {
    Name = "Eve"
  }
}
*/
#####################
# Resources Section #
#####################
#  create vpc
resource "aws_vpc" "vpc1" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = { Name = "vpc-1"}
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

# create users
resource "aws_iam_user" "managers" {
  count = length(var.users)
  name = var.users[count.index]

  tags = {
    Name = var.users[count.index]
  }
}

# Create a group
resource "aws_iam_group" "devops" {
  name="devops"
}

# attach policy to group
resource "aws_iam_group_policy_attachment" "attach" {
  group=aws_iam_group.devops.name
  policy_arn = data.aws_iam_policy.Administrator_Access.arn
}

# belongs to group
resource "aws_iam_group_membership" "devops" {
    name = aws_iam_group.devops.name
    count = length(var.users)
    users = [
        aws_iam_user.managers[count.index].name
    ]
    group = aws_iam_group.devops.name
}

# Create s3 bucket
resource "aws_s3_bucket" "bucket1" {
  bucket = "terraform-kdigital-shop-20240604-1"
}

# Create an instance using amazon ami
resource "aws_instance" "web" {
  # ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  count = 3
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [ 
    aws_security_group.management.id,
    # aws_security_group.mysql.id
    ]
  subnet_id = data.aws_subnet.subnet-0.id

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
  vpc_security_group_ids = [ 
    aws_security_group.management.id,
    # aws_security_group.mysql.id
    ]
  subnet_id = data.aws_subnet.subnet-16.id
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
resource "aws_instance" "web-2" {
  # ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [ aws_security_group.management.id ]
}
*/

# Create public key
resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}