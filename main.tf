provider "aws" {
  region = var.region
}

module "network" {
  source = "./network"
}

module "instance" {
  source = "./instance"
  vpc1 = module.network.vpc1
  sg_management_id = module.securitygroup.sg_management_id
  public-subnet-0 = module.network.public-subnet-0
  public-subnet-16 = module.network.public-subnet-16
  public-subnet-32 = module.network.public-subnet-32
  public-subnet-48 = module.network.public-subnet-48
  private-subnet-64 = module.network.private-subnet-64
  private-subnet-80 = module.network.private-subnet-80
  private-subnet-96 = module.network.private-subnet-96
  private-subnet-112 = module.network.private-subnet-112
}

module "securitygroup" {
  source = "./securitygroup"
  vpc1 = module.network.vpc1
}

module "route53" {
  source = "./route53"
  public_ip_1 = module.instance.public_ip_1
  public_ip_2 = module.instance.public_ip_2
  public_ip_3 = module.instance.public_ip_3
  public_ip_4 = module.instance.public_ip_4
}

module "loadbalancer" {
  source = "./loadbalancer"
  vpc1 = module.network.vpc1
  aws_key_pair = module.instance.aws_key_pair
  aws_route53_zone = module.route53.aws_route53_zone
  sg_management_id = module.securitygroup.sg_management_id
  vpc1-private-subnets = module.network.vpc1-private-subnets[*].id
  public-subnet-0 = module.network.public-subnet-0
  public-subnet-16 = module.network.public-subnet-16
  public-subnet-32 = module.network.public-subnet-32
  public-subnet-48 = module.network.public-subnet-48
  private-subnet-64 = module.network.private-subnet-64
  private-subnet-80 = module.network.private-subnet-80
  private-subnet-96 = module.network.private-subnet-96
  private-subnet-112 = module.network.private-subnet-112
}