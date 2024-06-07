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

output "vpc1" {
  value = aws_vpc.vpc1.id
}

output "public-subnet-0" {
  value = aws_subnet.vpc1-public-subnet-0.id
}

output "public-subnet-16" {
  value = aws_subnet.vpc1-public-subnet-16.id
}

output "public-subnet-32" {
  value = aws_subnet.vpc1-public-subnet-32.id
}

output "public-subnet-48" {
  value = aws_subnet.vpc1-public-subnet-48.id
}

output "private-subnet-64" {
  value = aws_subnet.vpc1-private-subnet-64.id
}

output "private-subnet-80" {
  value = aws_subnet.vpc1-private-subnet-80.id
}

output "private-subnet-96" {
  value = aws_subnet.vpc1-private-subnet-96.id
}

output "private-subnet-112" {
  value = aws_subnet.vpc1-private-subnet-112.id
}