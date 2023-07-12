module "network" {
  source = "./modules/network"
  availability_zones = var.availability_zones
  cidr_block = var.cidr_blocks
}


module "instance" {
  source = "./modules/instance"
  instance_type = var.instance_type
//module.network.public_subnets ⇐ vars.tf
  subnet_id     =  module.network.public_subnets[0]
//module.securitygroup.ssh_sg_id ⇐ output.tf
  sg_id = module.securitygroup.ssh_sg_id
  depends_on = [
    module.network,
    module.securitygroup
  ]
}


module "securitygroup" {
  source = "./modules/securitygroup"
// vpc_id from modules/network/outputs.tf
  vpc_id = module.network.vpc_id 
 depends_on = [
    module.network
  ]
 }