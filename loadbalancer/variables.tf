variable "vpc1" {
  type = string
}

variable "aws_key_pair" {
  type = string
}

variable "sg_management_id" {
  type = string
}

variable "public-subnet-0" {
  type = string
}
variable "public-subnet-16" {
  type = string
}
variable "public-subnet-32" {
  type = string
}
variable "public-subnet-48" {
  type = string
}
variable "private-subnet-64" {
  type = string
}
variable "private-subnet-80" {
  type = string
}
variable "private-subnet-96" {
  type = string
}
variable "private-subnet-112" {
  type = string
}

variable "aws_route53_zone" {
  type = string
}

variable "vpc1-private-subnets" {
  # type = list(string)
}