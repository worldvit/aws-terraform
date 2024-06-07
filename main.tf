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