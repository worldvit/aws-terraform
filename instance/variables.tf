variable "vpc1" {
  type = string
}

variable "inst-type" {
  type = string
  default = "t2.micro"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/mykey.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "keys/mykey"
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