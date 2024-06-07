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

variable "subnet-0" {
  type = string
}
variable "subnet-16" {
  type = string
}
variable "subnet-32" {
  type = string
}
variable "subnet-48" {
  type = string
}