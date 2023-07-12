variable "availability_zones" {
  description = "Define availability zones"
}


variable "cidr_block" {
  description = "Define cidr blocks"
}


variable "public_subnets" {
  default = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24",]
}


variable "private_subnets" {
  default = ["10.10.101.0/24","10.10.102.0/24","10.10.103.0/24",]
}
